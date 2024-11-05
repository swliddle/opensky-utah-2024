//
//  OpenSkyUtahView.swift
//  OpenSkyUtah
//
//  Created by Stephen Liddle on 11/5/24.
//

import SwiftUI

struct OpenSkyUtahView: View {

    let openSkyService: OpenSkyService

    var body: some View {
        TabView {
            aircraftList
                .tabItem {
                    Label("Aircraft", systemImage: "list.triangle")
                }

            aircraftMap
                .tabItem {
                    Label("Map", systemImage: "map")
                }
        }
        .onAppear {
            openSkyService.loadSampleData()
        }
    }

    private var aircraftList: some View {
        NavigationStack {
            List {
                ForEach(openSkyService.aircraftStates) { aircraftState in
                    AircraftStateCell(aircraftState: aircraftState)
                }
            }
            .listStyle(.plain)
            .navigationTitle(Constants.title)
        }
    }

    private var aircraftMap: some View {
        Text("Aircraft Map Coming Soon")
    }

    // MARK: - Constants

    private struct Constants {
        static let title = "OpenSky Utah"
    }
}
