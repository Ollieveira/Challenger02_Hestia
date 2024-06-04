//
//  OnBoarding3.swift
//  Challenger02_Hestia
//
//  Created by Willys Oliveira on 16/05/24.
//

import SwiftUI

struct OnBoarding1: View {
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("Voice Guide")
                .font(.largeTitle).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundStyle(Color.onBoradingButtonCor)
            
            Spacer()
            
            Image(systemName: "r.square.fill")
                .font(.custom("foward", size: 102))
                .fontWeight(.bold)
                .foregroundStyle(Color.onBoradingButtonCor)
            
            Spacer()
            
            (
                Text("Say")
                +
                Text(" 'Read' ")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)            +
                Text("to start listening the recipe")
            )
            .font(.title3)
            .foregroundStyle(Color.onBoradingButtonCor)

            
            Spacer()
        }
    }
}

#Preview {
    OnBoarding1()
}
