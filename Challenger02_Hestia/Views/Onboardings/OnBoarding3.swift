//
//  OnBoarding1.swift
//  Challenger02_Hestia
//
//  Created by Willys Oliveira on 16/05/24.
//

import SwiftUI

struct OnBoarding3: View {
    var body: some View {
        VStack {
            VStack {
                Text("Controle de voz")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(Color.backgroundCor)
                
                Spacer()
                
                Image(systemName: "forward.fill")
                    .font(.custom("foward", size: 102))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.backgroundCor)
                    .offset(y: -30)

                
                (
                    Text("Diga")
                    +
                    Text(" ”Passe” ")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)            +
                    Text("para ir para o próximo passo")
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
                .padding(.top, 42)
            
            
            Text("Passo a Passo")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(.semibold)
                .foregroundStyle(Color.tabViewCor)
                .padding()

            Text("Leia as instruções atentamente a respeito dos comandos de voz.")
                .font(.headline).fontWeight(.regular)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.gray)
                .padding(.horizontal, 42)

        }
        .padding(.bottom, 50)

    }
}

#Preview {
    OnBoarding3()
}
