//
//  OnBoarding2.swift
//  Challenger02_Hestia
//
//  Created by Willys Oliveira on 16/05/24.
//

import SwiftUI

struct OnBoarding5: View {
    
    @Binding var hasSeenOnboarding: Bool
    
    var body: some View {
        VStack (alignment:.center, spacing: 32 ) {
            
            Text("Passo a Passo")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(.semibold)
                .foregroundStyle(Color.tabViewCor)
                .padding()
            VStack {
                Text("Controle de voz")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(Color.backgroundCor)
                
                Spacer()
                
                Image(systemName: "backward.fill")
                    .font(.custom("foward", size: 102))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.backgroundCor)
                    .offset(y: -30)

                
                (
                    Text("Diga")
                    +
                    Text(" ”Volte” ")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)            +
                    Text("para retornar ao passo anterior")
                )
                .font(.title3).fontWeight(.regular)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.backgroundCor)
                .padding(.horizontal, 62)


            }
            .padding(.vertical, 100)
            .background (
                Image("FundoOnBoarding")
            )
            .frame(width: 360, height: 450)
            
            Divider()
                .padding(.top, 16)
            
            
            
            Button(action: {
                hasSeenOnboarding = true
            }) {
                Text("Começar")
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
            .offset(y: -10)


        }
        .padding(.bottom, 39)

//        VStack {
//            
//            Spacer()
//            
//            Text("Guia de voz")
//                .font(.largeTitle).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
//                .foregroundStyle(Color.onBoradingButtonCor)
//            
//            Spacer()
//            
//            Image(systemName: "backward.fill")
//                .font(.custom("foward", size: 102))
//                .fontWeight(.bold)
//                .foregroundStyle(Color.onBoradingButtonCor)
//            
//            Spacer()
//            
//            (
//                Text("Diga")
//                +
//                Text(" 'Volte' ")
//                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)            +
//                Text("para retornar a etapa anterior")
//            )
//            .font(.title3)
//            .foregroundStyle(Color.onBoradingButtonCor)
//            
//            
//            Spacer()
//            Button(action: {
//                hasSeenOnboarding = true
//            }) {
//                Text("OK")
//                    .foregroundColor(.backgroundCor)
//                    .font(.headline)
//                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
//                    .padding()
//                    .padding(.horizontal, 32)
//                    .background(
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(.onBoradingButtonCor)
//                    )
//            }
//            Spacer()
//        }
    }
}

#Preview {
    OnBoarding5(hasSeenOnboarding: .constant(true))
}
