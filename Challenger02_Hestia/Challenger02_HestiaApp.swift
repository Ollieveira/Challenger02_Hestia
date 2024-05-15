//
//  Challenge2App.swift
//  Challenge2
//
//  Created by Guilherme Avila on 26/04/24.
//

import SwiftUI

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
}

#Preview {
    TheTabView()
}
