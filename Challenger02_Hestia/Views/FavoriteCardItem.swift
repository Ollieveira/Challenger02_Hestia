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
                        image
                            .resizable()
                            .scaledToFill()
                        
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 116, height: 92)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    
                    VStack (alignment: .leading) {
                        Text(recipeTitle)
                            .font(.title3).fontWeight(.semibold)
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        
                        Text(region.capitalizingFirstLetter())
                            .font(.footnote)
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
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2)
                )
                .frame(maxWidth: .infinity, maxHeight: 92)
                .background(Color.backgroundCor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 16).padding(.bottom, 8)

            })
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}
