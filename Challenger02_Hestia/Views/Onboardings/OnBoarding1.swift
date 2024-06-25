//
//  OnBoarding1.swift
//  Challenger02_Hestia
//
//  Created by Willys Oliveira on 21/06/24.
//

import SwiftUI

struct OnBoarding1: View {
    var body: some View {
        VStack (alignment:.center, spacing: 32 ) {
            Text("Passo a Passo")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(.semibold)
                .foregroundStyle(Color.tabViewCor)
                .padding()

            VStack {
                Text("Atente-se a cor!")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(Color.backgroundCor)
                
                Spacer()
                
                Text("Quando estiver azul, aguarde ficar vermelho")
                    .font(.title3).fontWeight(.regular)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.backgroundCor)
                    .padding(.horizontal, 62)


            }
            .padding(.vertical, 100)
            .background (
                Image("PanelaAzul")
            )
            .frame(width: 360, height: 450)
            
            Divider()
                .padding(.top, 16)
            
            

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
    OnBoarding1()
}
