//
//  ButtonStyleMenuView.swift
//  Challenger02_Hestia
//
//  Created by Willys Oliveira on 03/05/24.
//

import SwiftUI

struct MenuCategory: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let filterName: String
    let icons: [Image]
    var isFavorite: Bool
}

struct ButtonStyleMenuView: View {
    @State var viewModel = MealViewModel.instance
    @State private var menus = [
//        MenuCategory(name: "Favorites", filterName: "nonFavorite", icons: [Image("Favorites_Selected"), Image ("Favorites_Unselected")] , isFavorite: false),
        MenuCategory(name: "Safe for Vegans", filterName: "Non-Vegan", icons: [Image("Vegan_Symbol_Selected"), Image ("Vegan_Symbol_Unselected") ], isFavorite: false),
        MenuCategory(name: "Dairy Free", filterName: "Non-Dairy-Free",  icons: [Image("Dairy_Free_Symbol_Selected"), Image ("Dairy_Free_Symbol_Unselected")] , isFavorite: false),
        MenuCategory(name: "Gluten Free", filterName: "Non-Gluten-Free", icons: [Image("Gluten_Free_Symbol_Selected"), Image ("Gluten_Free_Symbol_Unselected")] , isFavorite: false),
        MenuCategory(name: "Egg Free", filterName: "Non-Egg-Free", icons: [Image("Egg_Free_Symbol_Selected"), Image ("Egg_Free_Symbol_Unselected")] , isFavorite: false),
        MenuCategory(name: "Seafood Free", filterName: "Non-Seafood-Free", icons: [Image("Seafood_Free_Symbol_Selected"), Image ("Seafood_Free_Symbol_Unselected")] , isFavorite: false),
        MenuCategory(name: "Soy Free", filterName: "Non-Soy-Free", icons: [Image("Soy_Free_Symbol_Selected"), Image ("Soy_Free_Symbol_Unselected")] , isFavorite: false),
        MenuCategory(name: "Sugar Free", filterName: "Non-Sugar-Free", icons: [Image("Sugar_Free_Symbol_Selected"), Image ("Sugar_Free_Symbol_Unselected")] , isFavorite: false),
        MenuCategory(name: "Nut Free", filterName: "Non-Peanut-Free", icons: [Image("Nut_Free_Symbol_Selected"), Image ("Nut_Free_Symbol_Unselected")] , isFavorite: false)
    ]

    var body: some View {
        VStack (spacing:0){
            HStack{
                Text("Restrições Alimentares e Dieta")
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    limparTudo()
                } label: {
                    Text("limpar tudo")
                        .foregroundStyle(.filterActiveCor)
                        .fontWeight(.light)
                        .font(.caption2)
                }
            }
                .padding(.horizontal, 15)
                .padding(.bottom, 15)
            ScrollView(.horizontal, showsIndicators: false) {
                VStack {
                    HStack(alignment: .bottom,  spacing: 15) {
                        ForEach($menus) { $menuCategory in
                            Button {
                                menuCategory.isFavorite.toggle()
                                if viewModel.activeFilters.contains(menuCategory.filterName) {
                                    viewModel.removeFilter(restriction: menuCategory.filterName)
                                }
                                else {
                                    viewModel.addFilter(restriction: menuCategory.filterName)
                                }
                            } label: {
                                HStack (alignment: .bottom){
                                    VStack (alignment: .center){
                                        (viewModel.activeFilters.contains(menuCategory.filterName) ? menuCategory.icons[0] : menuCategory.icons[1])
                                        Text(menuCategory.name)
                                            .foregroundStyle(viewModel.activeFilters.contains(menuCategory.filterName) ? Color(.filterActiveCor): Color(.filterUnactiveCor))
                                            .font(.caption2)
                                            .fontDesign(.rounded)
                                            .fontWeight(.regular)
                                            .padding(.top, 2)
                                        Divider()
                                            .padding(.vertical, 0)
                                            .frame(height: 0.5)
                                            .background(viewModel.activeFilters.contains(menuCategory.filterName) ? Color(.filterActiveCor) : .clear)
                                            
                                    }
                                    
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 15)
                   
                }
            }

            Divider()
                .padding(.top, 0)
                .frame(height: 0.5)
                .background(Color(.filterUnactiveCor))
        }
    }
    
    private func limparTudo() {
            // Set all menu categories to not favorite
            for i in menus.indices {
                menus[i].isFavorite = false
            }
            // Clear all active filters in the view model
            viewModel.removeAllFilters()
        }
}

struct ButtonStyleMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonStyleMenuView()
    }
}
