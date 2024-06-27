import SwiftUI

struct MealsListView: View {
    @State var viewModel = MealViewModel.instance
    let alphabet = Array("abcdefghijklmnoprstvwy") // Retiramos q u x z

    var body: some View {
        VStack {
            ScrollView {
                HStack(spacing: 20) {
                    LazyVStack(spacing: 20) {
                        ForEach(Array(viewModel.filteredMeals.indices.filter { $0 % 2 == 0 }), id: \.self) { index in
                            navigationLink(for: index, isLeftColumn: true)
                        }
                        Spacer()
                    }
                    VStack {
                        LazyVStack(spacing: 20) {
                            ForEach(Array(viewModel.filteredMeals.indices.filter { $0 % 2 != 0 }), id: \.self) { index in
                                navigationLink(for: index, isLeftColumn: false)
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top, 32)
        .onAppear {
            if viewModel.meals.isEmpty {
                viewModel.loadAllMeals()
            }
        }
    }

    @ViewBuilder
    private func navigationLink(for index: Int, isLeftColumn: Bool) -> some View {
        NavigationLink {
            let mealID = viewModel.filteredMeals[index].id
            let mealBinding = Binding<Meal> {
                let index = viewModel.meals.firstIndex(where: { $0.id == mealID })!
                return viewModel.meals[index]
            } set: { newValue in
                let index = viewModel.meals.firstIndex(where: { $0.id == mealID })!
                viewModel.meals[index] = newValue
            }
            
            MealDetailView(meal: mealBinding)
                .toolbar(.hidden, for: .tabBar)
        } label: {
            MealRow(meal: viewModel.filteredMeals[index], indexInGrid: index, isLeftColumn: isLeftColumn)
        }
    }
}
