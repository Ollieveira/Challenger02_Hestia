//
//  RouterViews.swift
//  Challenger02_Hestia
//
//  Created by Willys Oliveira on 03/05/24.
//

import Foundation
import SwiftUI

struct RouterViews: View {
    @State private var router: Router = .theTabView
    @State private var choosenMeal: Meal? = nil

    

    var body: some View {
        
        ZStack {
            switch router {
            case .mealsListView:
                MealsListView(router: $router, chosenMeal: $choosenMeal)
                
            case .mealDetailView:
                MealDetailView(router: $router, meal: Binding.constant(choosenMeal!))
                
            case .speechView:
                SpeechView(recipeSteps: choosenMeal!.instructionSteps)
                
            case .theTabView:
                TheTabView(router: $router, chosenMeal: $choosenMeal)
            }
        }
        
    }
}

enum Router {
    case mealsListView
    case mealDetailView
    case speechView
    case theTabView
}
