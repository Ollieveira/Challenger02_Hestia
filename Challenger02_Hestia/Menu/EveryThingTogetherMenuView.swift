//
//  EveryThingTogetherMenuView.swift
//  Challenger02_Hestia
//
//  Created by Willys Oliveira on 03/05/24.
//

import SwiftUI

struct EverythingTogetherMenuView: View {
    @Binding var router: Router
    @Binding var chosenMeal: Meal?
    @State var favorite: Bool = false
    
    var body: some View {
        ZStack {
            Color(.backgroundcolor)
                .ignoresSafeArea()
            
            VStack{
                (
                    Text("It's time to cook your")
                    +
                    Text(" hungry ")
                        .foregroundStyle(.buttoncolor)
                    +
                    Text("out!")
                )
                .font(.title2)
                .fontDesign(.rounded)
                .bold()
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
        
                ButtonStyleMenuView()
                
                
                MealsListView(router: $router, chosenMeal: $chosenMeal)
                

                
            }
        }
    }
}

//#Preview {
//    EverythingTogetherMenuView()
//}
