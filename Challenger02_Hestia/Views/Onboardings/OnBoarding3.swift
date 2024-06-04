//
//  OnBoarding2.swift
//  Challenger02_Hestia
//
//  Created by Willys Oliveira on 16/05/24.
//

import SwiftUI

struct OnBoarding3: View {
    
    @Binding var hasSeenOnboarding: Bool
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("Voice Guide")
                .font(.largeTitle).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundStyle(Color.onBoradingButtonCor)
            
            Spacer()
            
            Image(systemName: "backward.fill")
                .font(.custom("foward", size: 102))
                .fontWeight(.bold)
                .foregroundStyle(Color.onBoradingButtonCor)
            
            Spacer()
            
            (
                Text("Say")
                +
                Text(" 'Back' ")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)            +
                Text("to go to the previous step")
            )
            .font(.title3)
            .foregroundStyle(Color.onBoradingButtonCor)
            
            
            Spacer()
            Button(action: {
                hasSeenOnboarding = true
            }) {
                Text("OK")
                    .foregroundColor(.backgroundCor)
                    .font(.headline)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding()
                    .padding(.horizontal, 32)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.onBoradingButtonCor)
                    )
            }
            Spacer()
        }
    }
}

#Preview {
    OnBoarding3(hasSeenOnboarding: .constant(true))
}
