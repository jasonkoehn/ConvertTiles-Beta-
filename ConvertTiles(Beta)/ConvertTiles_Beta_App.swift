//
//  ConvertTiles_Beta_App.swift
//  ConvertTiles(Beta)
//
//  Created by Jason Koehn on 12/12/22.
//

import SwiftUI

@main
struct ConvertTiles_Beta_App: App {
    @AppStorage("hlb") var hasLaunchedBefore: Bool = false
    var body: some Scene {
        WindowGroup {
            if hasLaunchedBefore {
                MainView()
            } else {
                LaunchView(hasLaunchedBefore: $hasLaunchedBefore)
            }
        }
    }
}
