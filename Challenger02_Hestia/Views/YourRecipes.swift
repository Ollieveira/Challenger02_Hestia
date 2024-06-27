//
//  YourRecipes.swift
//  Challenger02_Hestia
//
//  Created by Willys Oliveira on 14/05/24.
//

import SwiftUI
import TelemetryClient

struct YourRecipes: View {
    
    @State var viewModel = MealViewModel.instance
    
    
    var body: some View {
        VStack {
            (
                Text("Confira seus")
                +
                Text(" favoritos ")
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
                
                ScrollView(.vertical, showsIndicators: true) {
                    ForEach($viewModel.favoriteMeals, id: \.id) { favoriteMeal in
                        // Find the index of the favorite meal in viewModel.meals
                        if let favoriteIndex = $viewModel.meals.firstIndex(where: { $0.id == favoriteMeal.id }) {
                            FavoriteCard(imageUrl: (viewModel.meals[favoriteIndex].strMealThumb ?? URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgwLS8cVj9jxd6gxPlGrLJCcSBDyI5XkQs8g&s"))!,
                                         recipeTitle: viewModel.meals[favoriteIndex].strMeal,
                                         region: viewModel.meals[favoriteIndex].area ?? "",
                                         deleteIcon: "trash.fill",
                                         meal: $viewModel.meals[favoriteIndex])
                        }
                    }
                }
            } else {
                
                Spacer()
                
                Text("Você ainda não tem nenhuma receita favorita")
                    .font(.title2)
                    .fontDesign(.rounded)
                    .bold()
                    .padding()
                    .foregroundStyle(Color.gray)
                
                Spacer()

                
            }
        }
        .onAppear{
            TelemetryManager.send("viewAppear", with: ["page": "Favorites"])
        }
        .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(Color.backgroundCor.edgesIgnoringSafeArea(.all))
    }
    
}


//#Preview {
//    YourRecipes()
//}
