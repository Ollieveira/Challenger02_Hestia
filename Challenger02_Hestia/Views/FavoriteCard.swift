//
//  FavoriteCard.swift
//  Challenger02_Hestia
//
//  Created by Willys Oliveira on 14/05/24.
//

import SwiftUI

struct FavoriteCard: View {
    
    let imageUrl: URL
    let recipeTitle: String
    let region: String
//    let tags: [String]?
    
    
    var body: some View {
        HStack {
            AsyncImage(url: imageUrl) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            
            VStack {
                Text(recipeTitle)
                
                Text(region)
                
//                ForEach(Array(tags?.enumerated() ?? [].enumerated()), id: \.element) { index, tag in
//                    Text(tag)
//                        .font(.footnote)
//                        .padding(.horizontal, 6)
//                        .padding(.vertical, 4)
//                        .background(RoundedRectangle(cornerRadius: 8)
//                            .stroke(Color.tabViewCor, lineWidth: 2))
//                }
            }
        

        }
    }
}

//#Preview {
//    FavoriteCard(imageUrl: <#URL#>, recipeTitle: <#String#>, region: <#String#>, tags: <#[String]?#>)
//}
