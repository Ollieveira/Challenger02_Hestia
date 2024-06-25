//
//  OnBoardingView.swift
//  Challenger02_Hestia
//
//  Created by Willys Oliveira on 16/05/24.
//

import SwiftUI

struct OnBoardingView: View {
    
    @State var currentPage: Int = 1
    @Binding var hasSeenOnboarding: Bool
    
    var body: some View {
        NavigationStack {
            ZStack{
                TabView (selection: $currentPage) {
                    OnBoarding1()
                        .tag(1)
                    OnBoarding2()
                        .tag(2)
                    OnBoarding3()
                        .tag(3)
                    OnBoarding4()
                        .tag(4)
                    OnBoarding5(hasSeenOnboarding: $hasSeenOnboarding)
                        .tag(5)
                    
                    
                }
                .font(.largeTitle)
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            }
            .background(Color.backgroundCor)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(trailing: skipButton)
        }

    }
    
    private var skipButton: some View {
        Button(action: {
            hasSeenOnboarding = true
        }) {
            Text("Pular")
                .foregroundColor(Color.tabViewCor)
        }
        .opacity(currentPage == 5 ? 0 : 1) // Esconde o botão "Skip" na última página
    }

}

#Preview {
    OnBoardingView(hasSeenOnboarding: .constant(true))
}
