//
//  FavoriteCard.swift
//  Challenger02_Hestia
//
//  Created by Willys Oliveira on 14/05/24.
//

import SwiftUI

struct FavoriteCard: View {
    
    @StateObject var viewModel = MealViewModel.instance

    
    let imageUrl: URL
    let recipeTitle: String
    let region: String
//    let tags: [String]?
    let deleteIcon: String
    @Binding var meal: Meal
    @State private var showingAlert = false

    
    
    var body: some View {
        NavigationLink (
            destination: MealDetailView(meal: $meal)
            ,
                       label: {
            HStack (alignment: .top){
                AsyncImage(url: imageUrl) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 122, height: 112)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                
                VStack (alignment: .leading) {
                    Text(recipeTitle)
                        .font(.title3).fontWeight(.semibold)
                    
                    Text(region)
                        .font(.footnote)
                    
                    //                ForEach(Array(tags?.enumerated() ?? [].enumerated()), id: \.element) { index, tag in
                    //                    Text(tag)
                    //                        .font(.footnote)
                    //                        .padding(.horizontal, 6)
                    //                        .padding(.vertical, 4)
                    //                        .background(RoundedRectangle(cornerRadius: 8)
                    //                            .stroke(Color.tabViewCor, lineWidth: 2))
                    //                }
                }
                .padding(.vertical, 8)
                
                Spacer()
                Button(action: {
                    self.showingAlert = true
                }, label: {
                    Image(systemName: deleteIcon)
                        .foregroundStyle(Color.tabViewCor)
                        .font(.footnote)
                        .padding(.vertical, 8)
                        .padding(.trailing, 8)
                })
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Delete Favorite"),
                        message: Text("Are you sure you want to delete \(recipeTitle)"),
                        primaryButton: .destructive(Text("Delete")) {
                            viewModel.removeFromFavorites(meal: meal)
                        },
                        secondaryButton: .cancel()
                    )
                }
                
                
                
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 112)
            .background(Color.bgFavCardCor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 16)
        })
    }
}
