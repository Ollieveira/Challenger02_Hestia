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
    @StateObject var viewModel = MealViewModel.instance
    @State private var menus = [
//        MenuCategory(name: "Favorites", filterName: "nonFavorite", icons: [Image("Favorites_Selected"), Image ("Favorites_Unselected")] , isFavorite: false),
        MenuCategory(name: "Vegan", filterName: "Non-Vegan", icons: [Image("Vegan_Symbol_Selected"), Image ("Vegan_Symbol_Unselected") ], isFavorite: false),
        MenuCategory(name: "Dairy Free", filterName: "Non-Dairy-Free",  icons: [Image("Dairy_Free_Symbol_Selected"), Image ("Dairy_Free_Symbol_Unselected")] , isFavorite: false),
        MenuCategory(name: "Gluten Free", filterName: "Non-Gluten-Free", icons: [Image("Gluten_Free_Symbol_Selected"), Image ("Gluten_Free_Symbol_Unselected")] , isFavorite: false),
        MenuCategory(name: "Egg Free", filterName: "Non-Egg-Free", icons: [Image("Egg_Free_Symbol_Selected"), Image ("Egg_Free_Symbol_Unselected")] , isFavorite: false),
        MenuCategory(name: "Seafood Free", filterName: "Non-Seafood-Free", icons: [Image("Seafood_Free_Symbol_Selected"), Image ("Seafood_Free_Symbol_Unselected")] , isFavorite: false),
        MenuCategory(name: "Soy Free", filterName: "Non-Soy-Free", icons: [Image("Soy_Free_Symbol_Selected"), Image ("Soy_Free_Symbol_Unselected")] , isFavorite: false),
        MenuCategory(name: "Sugar Free", filterName: "Non-Sugar-Free", icons: [Image("Sugar_Free_Symbol_Selected"), Image ("Sugar_Free_Symbol_Unselected")] , isFavorite: false),
        MenuCategory(name: "Nut Free", filterName: "Non-Peanut-Free", icons: [Image("Nut_Free_Symbol_Selected"), Image ("Nut_Free_Symbol_Unselected")] , isFavorite: false)
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
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
                        VStack {
                            (viewModel.activeFilters.contains(menuCategory.filterName) ? menuCategory.icons[0] : menuCategory.icons[1])
                            Text(menuCategory.name)
                                .foregroundStyle(.textFilterCor)
                                .font(.caption2)
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct ButtonStyleMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonStyleMenuView()
    }
}
