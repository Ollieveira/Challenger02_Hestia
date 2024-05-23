//
//  EveryThingTogetherMenuView.swift
//  Challenger02_Hestia
//
//  Created by Willys Oliveira on 03/05/24.
//

import SwiftUI
import TelemetryClient

struct EverythingTogetherMenuView: View {
    @State var favorite: Bool = false
    @State var isFirstLoad: Bool = true
    @State private var viewAppearTime: Date?

    
    var body: some View {
        NavigationStack {
            VStack {
                (
                    Text("It's time to cook your")
                    +
                    Text(" hungry ")
                        .foregroundStyle(.tabViewCor)
                    +
                    Text("out!")
                )
                .font(.title2)
                .fontDesign(.rounded)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                
                ButtonStyleMenuView()
                
                MealsListView()
            }
            .onAppear {
                // Registra o momento em que a view aparece
                viewAppearTime = Date()
            }
            .onDisappear {
                // Calcula o tempo que a view ficou visível
                if let viewAppearTime = viewAppearTime {
                    let viewDisappearTime = Date()
                    let duration = viewDisappearTime.timeIntervalSince(viewAppearTime)
                    // Envia o sinal de telemetria com a duração
                    TelemetryManager.send("viewDuration", floatValue: duration, with: ["page": "MainPage"])
                }
            }
            .background(Color.backgroundCor)
        }
    }
}

//#Preview {
//    EverythingTogetherMenuView()
//}
