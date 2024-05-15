import SwiftUI

struct MealsListView: View {
    @StateObject var viewModel = MealViewModel.instance
    let alphabet = Array("abcdefghijklmnoprstvwy") // Retiramos q u x z

    var body: some View {
        VStack {
            if viewModel.isLoading {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .tabViewCor))
                    .scaleEffect(2)
                Spacer()
            } else {
                ScrollView {
                    HStack(spacing: 20) {
                        LazyVStack (spacing:20){
                            ForEach(Array(viewModel.meals.indices.filter { $0 % 2 == 0 }), id: \.self) { index in
                                NavigationLink(
                                    destination: MealDetailView(meal: $viewModel.meals[index])
                                        .toolbar(.hidden, for: .tabBar)
                                ) {
                                    MealRow(meal: viewModel.meals[index], indexInGrid: index, isLeftColumn: true)
                                }
                                .onAppear {
                                    if index == viewModel.meals.count - 1 {
                                        // Load more meals if needed
                                        if let lastMeal = viewModel.meals.last {
                                            if let lastLetter = lastMeal.strMeal.first,
                                               let nextLetterIndex = alphabet.firstIndex(of: lastLetter)?.advanced(by: 1),
                                               nextLetterIndex < alphabet.count {
                                                Task {
                                                    await viewModel.getAllMeals(for: alphabet[nextLetterIndex])
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }
                        VStack{
                            LazyVStack (spacing: 20) {
                                ForEach(Array(viewModel.meals.indices.filter { $0 % 2 != 0 }), id: \.self) { index in
                                    NavigationLink(
                                        destination: MealDetailView(meal: $viewModel.meals[index])
                                            .toolbar(.hidden, for: .tabBar)
                                    ) {
                                        MealRow(meal: viewModel.meals[index], indexInGrid: index, isLeftColumn: false)
                                    }
                                    .onAppear {
                                        if index == viewModel.meals.count - 1 {
                                            // Load more meals if needed
                                            if let lastMeal = viewModel.meals.last {
                                                if let lastLetter = lastMeal.strMeal.first,
                                                   let nextLetterIndex = alphabet.firstIndex(of: lastLetter)?.advanced(by: 1),
                                                   nextLetterIndex < alphabet.count {
                                                    Task {
                                                        await viewModel.getAllMeals(for: alphabet[nextLetterIndex])
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                               
                            }
                            Spacer()
                        }
                     
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top, 32)
        .onAppear {
            // Load meals if empty
            if viewModel.meals.isEmpty {
                Task {
                    viewModel.loadAllMeals()
                }
            }
        }
    }
}




