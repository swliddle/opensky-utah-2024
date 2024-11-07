//
//  OpenSkyUtahView.swift
//  OpenSkyUtah
//
//  Created by Stephen Liddle on 11/5/24.
//

import SwiftUI
import MapKit

struct OpenSkyUtahView: View {

    private struct Tab {
        static let list = 0
        static let map = 1
    }

    let openSkyService: OpenSkyService

    @State private var selectedTab = Tab.map

    var body: some View {
        TabView(selection: $selectedTab) {
            aircraftList
                .tabItem {
                    Label("Aircraft", systemImage: "list.triangle")
                }
                .tag(Tab.list)

            aircraftMap
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(Tab.map)
        }
        .onAppear {
            openSkyService.loadSampleData()
            openSkyService.refreshStatus()
        }
    }

    private var aircraftList: some View {
        NavigationStack {
            List {
                ForEach(openSkyService.locatedAircraftStates) { aircraftState in
                    AircraftStateCell(aircraftState: aircraftState)
                }
            }
            .listStyle(.plain)
            .navigationTitle(Constants.title)
            .toolbar { toolvarView }
        }
    }

    private var aircraftMap: some View {
        NavigationStack {
            Map(initialPosition: .region(Utah.region)) {
                ForEach(openSkyService.locatedAircraftStates) { aircraftState in
                    Annotation(
                        labelText(for: aircraftState),
                        coordinate: aircraftState.coordinate
                    ) {
                        Image(systemName: aircraftState.status.airborneImageName)
                            .imageScale(.large)
                            .foregroundStyle(.tint)
                            .rotationEffect(.degrees(aircraftState.heading))
                            .onTapGesture {
                                withAnimation {
                                    openSkyService
                                        .toggleDetailVisibility(for: aircraftState)
                                }
                            }
                    }
                }
            }
            .mapStyle(.standard)
            .mapControlVisibility(.visible)
            .navigationTitle(Constants.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolvarView }
        }
    }

    private func labelText(for aircraftState: AircraftState) -> String {
        if aircraftState.detailsVisible {
            """
            \(aircraftState.flight)
            \(aircraftState.altitude)
            \(aircraftState.speed)
            \(aircraftState.ascentRate)
            """
        } else {
            aircraftState.flight
        }
    }

    private var toolvarView: some View {
        Button {
            openSkyService.refreshStatus()
        } label: {
            Image(systemName: "arrow.clockwise")
                .imageScale(.large)
        }
    }

    // MARK: - Constants

    private struct Constants {
        static let title = "OpenSky Utah"
    }
}
