//
//  Challenge2App.swift
//  Challenge2
//
//  Created by Guilherme Avila on 26/04/24.
//

import SwiftUI
import TelemetryClient

@main
struct Challenge2App: App {
    
    @Environment(\.scenePhase) var scenePhase
    

    
    var body: some Scene {
        WindowGroup {
            TheTabView()
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .background:
                do {
                    try MealViewModel.instance.meals.save(in: "meals")
                    try MealViewModel.instance.favoriteMeals.save(in: "favoriteMeals")
                    print("salvou")
                } catch {
                    print("Se ferrou!", error)
                }
            case .inactive:
                break
            case .active:
                break
            @unknown default:
                break
            }
        }
    }
    
    init() {
        let configuration = TelemetryManagerConfiguration(
            appID: "5465312F-7D61-413A-BA0E-9FC4E2438E10")
        TelemetryManager.initialize(with: configuration)
        
        TelemetryManager.send("applicationDidFinishLaunching")

    }

}

#Preview {
    TheTabView()
}
