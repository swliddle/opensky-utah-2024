//
//  OpenSkyService.swift
//  OpenSkyUtah
//
//  Created by Stephen Liddle on 11/5/24.
//

import SwiftUI

@Observable class OpenSkyService {

    // MARK: - Properties

    private var aircraftStates: [AircraftState] = []

    // MARK: - Model access

    var locatedAircraftStates: [AircraftState] {
        aircraftStates.filter { $0.latitude != nil && $0.longitude != nil }
    }

    // MARK: - User intents
    func loadSampleData() {
        // Load sample data without touching the network
        if let url = Bundle.main.url(forResource: "SampleOpenSkyData", withExtension: "json") {
            if let data = try? Data(contentsOf: url) {
                updateStates(from: data)
            }
        }
    }

    func refreshStatus() {
        // Load Utah airplanes from the network API
        if let url = Utah.openSkyUrl {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data, error == nil {
                    self.updateStates(from: data)
                }
            }

            task.resume()
        }
    }

    func toggleDetailVisibility(for aircraftState: AircraftState) {
        // Toggle the visibility of this aircraft's detail box (on our map)
        if let selectedIndex = aircraftStates.firstIndex(matching: aircraftState) {
            aircraftStates[selectedIndex].detailsVisible.toggle()
        }
    }

    // MARK: - Private helpers

    private func transferPriorVisibility(from previousStates: [AircraftState]) {
        previousStates.forEach { previousState in
            if previousState.detailsVisible {
                if let selectedIndex = aircraftStates.firstIndex(matching: previousState) {
                    aircraftStates[selectedIndex].detailsVisible = previousState.detailsVisible
                }
            }
        }
    }

    private func updateStates(from data: Data) {
        DispatchQueue.main.async {
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String : Any] {
                if let states = json[Key.statesKey] as? [[Any]] {
                    let previousStates = self.aircraftStates

                    self.aircraftStates = []

                    states.forEach { aircraftState in
                        self.aircraftStates.append(AircraftState(from: aircraftState))
                    }

                    self.transferPriorVisibility(from: previousStates)
                }
            }
        }
    }

    // MARK: - Constants

    private struct Key {
        static let statesKey = "states"
    }
}
