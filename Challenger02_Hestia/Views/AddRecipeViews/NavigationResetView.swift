//
//  NavigationResetView.swift
//  Challenger02_Hestia
//
//  Created by Guilherme Avila on 04/06/24.
//

import Foundation
import SwiftUI

struct NavigationResetView<Content: View>: View {
    let destination: Content
    @Binding var isActive: Bool

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: destination, isActive: $isActive) {
                    EmptyView()
                }
                .isDetailLink(false) // Ensures that it resets the navigation stack
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .frame(width: 0, height: 0)
    }
}
