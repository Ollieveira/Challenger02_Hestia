//
//  FavoriteCard.swift
//  Challenger02_Hestia
//
//  Created by Willys Oliveira on 14/05/24.
//

import SwiftUI
import TelemetryClient

struct FavoriteCard: View {
    
    @State var viewModel = MealViewModel.instance

    
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
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    
                    Text(region.capitalizingFirstLetter())
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
                        title: Text("Deletar favorito"),
                        message: Text("Tem certeza de que deseja excluir \(recipeTitle)?"),
                        primaryButton: .destructive(Text("Deletar")) {
                            viewModel.removeFromFavorites(meal: meal)
                            TelemetryManager.send("buttonPress", with: ["button": "Removeu Favorites - FavoritesView"])

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

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}
