//
//  ClimaApp.swift
//  Clima
//
//  Created by Steven Zhang on 3/6/21.
//

import SwiftUI
// import Firebase

@main
struct ClimaApp: App {
    @ObservedObject var viewModel = RegionWeatherViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(viewModel)
            }
        }
    }
}
