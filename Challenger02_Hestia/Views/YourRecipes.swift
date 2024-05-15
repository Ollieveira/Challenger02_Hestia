//
//  YourRecipes.swift
//  Challenger02_Hestia
//
//  Created by Willys Oliveira on 14/05/24.
//

import SwiftUI

struct YourRecipes: View {
    
    @StateObject var viewModel = MealViewModel.instance
    
    
    var body: some View {
        VStack {
            (
                Text("Check out yout")
                +
                Text(" favorites ")
                    .foregroundStyle(.tabViewCor)
                +
                Text("!")
            )
            .font(.title2)
            .fontDesign(.rounded)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            if !viewModel.favoriteMeals.isEmpty {
                
                ScrollView (.vertical, showsIndicators: true) {
                    ForEach(viewModel.favoriteMeals, id: \.id) { meal in
                        // Substitua isso pelo código para renderizar cada refeição
                        
                        FavoriteCard(imageUrl: meal.strMealThumb, recipeTitle: meal.strMeal, region: meal.strArea, deleteIcon: "trash.fill", meal: meal)
                    }
                }
            } else {
                
                Spacer()
                
                Text("You don't have any favorite recipes yet")
                    .font(.title2)
                    .fontDesign(.rounded)
                    .bold()
                    .padding()
                    .foregroundStyle(Color.gray)
                
                Spacer()

                
            }
        }
        .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(Color.backgroundCor.edgesIgnoringSafeArea(.all))
    }
    
}


//#Preview {
//    YourRecipes()
//}
