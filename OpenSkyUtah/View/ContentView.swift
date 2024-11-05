//
//  ContentView.swift
//  OpenSkyUtah
//
//  Created by Stephen Liddle on 11/5/24.
//

import SwiftUI

struct ContentView: View {

    let openSkyService: OpenSkyService

    var body: some View {
        NavigationStack {
            List {
                ForEach(openSkyService.aircraftStates) { aircraftState in
                    HStack {
                        Text(aircraftState.flight)
                        Spacer()
                        Text(aircraftState.altitude)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            openSkyService.loadSampleData()
        }
    }
}
