//
//  OpenSkyUtahApp.swift
//  OpenSkyUtah
//
//  Created by Stephen Liddle on 11/5/24.
//

import SwiftUI

@main
struct OpenSkyUtahApp: App {
    var body: some Scene {
        WindowGroup {
            OpenSkyUtahView(openSkyService: OpenSkyService())
        }
    }
}
