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
    let icons: [Image]
    var isFavorite: Bool
}

struct ButtonStyleMenuView: View {
    @State private var menus = [
        MenuCategory(name: "Favorites", icons: [Image("Favorites_Selected"), Image ("Favorites_Unselected")] , isFavorite: false),
        MenuCategory(name: "Vegan", icons: [Image("Vegan_Symbol_Selected"), Image ("Vegan_Symbol_Unselected") ], isFavorite: false),
        MenuCategory(name: "Dairy Free", icons: [Image("Dairy_Free_Symbol_Selected"), Image ("Dairy_Free_Symbol_Unselected")] , isFavorite: false),
        MenuCategory(name: "Gluten Free", icons: [Image("Gluten_Free_Symbol_Selected"), Image ("Gluten_Free_Symbol_Unselected")] , isFavorite: false),
        MenuCategory(name: "Egg Free", icons: [Image("Egg_Free_Symbol_Selected"), Image ("Egg_Free_Symbol_Unselected")] , isFavorite: false),
        MenuCategory(name: "Seafood Free", icons: [Image("Seafood_Free_Symbol_Selected"), Image ("Seafood_Free_Symbol_Unselected")] , isFavorite: false),
        MenuCategory(name: "Soy Free", icons: [Image("Soy_Free_Symbol_Selected"), Image ("Soy_Free_Symbol_Unselected")] , isFavorite: false),

        MenuCategory(name: "Sugar Free", icons: [Image("Sugar_Free_Symbol_Selected"), Image ("Sugar_Free_Symbol_Unselected")] , isFavorite: false),
        MenuCategory(name: "Nut Free", icons: [Image("Nut_Free_Symbol_Selected"), Image ("Nut_Free_Symbol_Unselected")] , isFavorite: false)
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach($menus) { $menuCategory in
                    Button {
                        menuCategory.isFavorite.toggle()
                    } label: {
                        VStack {
                                (menuCategory.isFavorite ? menuCategory.icons[0] : menuCategory.icons[1])
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
