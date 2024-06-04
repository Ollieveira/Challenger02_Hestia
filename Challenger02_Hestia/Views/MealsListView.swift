import SwiftUI

struct MealsListView: View {
    @State var viewModel = MealViewModel.instance
    let alphabet = Array("abcdefghijklmnoprstvwy") // Retiramos q u x z

    var body: some View {
        VStack {
            if viewModel.isLoading {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .tabViewItemCor))
                    .scaleEffect(2)
                Spacer()
            } else {
                ScrollView {
                    HStack(spacing: 20) {
                        LazyVStack(spacing: 20) {
                            ForEach(Array(viewModel.filteredMeals.indices.filter { $0 % 2 == 0 }), id: \.self) { index in
                                NavigationLink {
                                    let mealID = viewModel.filteredMeals[index].id
                                    let mealBinding = Binding<Meal> {
                                        let index = viewModel.meals.firstIndex(where: {$0.id == mealID})!
                                        return viewModel.meals[index]
                                    } set: { newValue in
                                        let index = viewModel.meals.firstIndex(where: {$0.id == mealID})!
                                        viewModel.meals[index] = newValue
                                    }
                                    
                                    MealDetailView(meal: mealBinding)
                                        .toolbar(.hidden, for: .tabBar)
                                } label: {
                                    MealRow(meal: viewModel.filteredMeals[index], indexInGrid: index, isLeftColumn: true)
                                }
                                .onAppear {
                                    if index == viewModel.filteredMeals.count - 1 {
                                        // Load more meals if needed
                                        if let lastMeal = viewModel.filteredMeals.last {
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
                            LazyVStack(spacing: 20) {
                                ForEach(Array(viewModel.filteredMeals.indices.filter { $0 % 2 != 0 }), id: \.self) { index in
                                    NavigationLink {
                                        let mealID = viewModel.filteredMeals[index].id
                                        let mealBinding = Binding<Meal> {
                                            let index = viewModel.meals.firstIndex(where: {$0.id == mealID})!
                                            return viewModel.meals[index]
                                        } set: { newValue in
                                            let index = viewModel.meals.firstIndex(where: {$0.id == mealID})!
                                            viewModel.meals[index] = newValue
                                        }

                                        MealDetailView(meal: mealBinding)
                                            .toolbar(.hidden, for: .tabBar)
                                    } label: {
                                        MealRow(meal: viewModel.filteredMeals[index], indexInGrid: index, isLeftColumn: false)
                                    }
                                    .onAppear {
                                        if index == viewModel.filteredMeals.count - 1 {
                                            // Load more meals if needed
                                            if let lastMeal = viewModel.filteredMeals.last {
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
