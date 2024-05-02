import SwiftUI
import Combine

struct MealsListView: View {
    @Binding var routerState:Int
    @Binding var chosenMeal: Meal?
    
    @StateObject var viewModel = MealViewModel()
    @State private var searchTimer: Timer?
    let alphabet = Array("abcdefghijklmnopqrstuvwxyz")
    
    var body: some View {
            VStack {
                Picker("Search Type", selection: $viewModel.searchType) {
                    Text("Name").tag(MealViewModel.SearchType.name)
                    Text("Letter").tag(MealViewModel.SearchType.letter)
                    Text("Category").tag(MealViewModel.SearchType.category)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if viewModel.searchType == .category {
                    CategoryListView()
                } else {
                    if viewModel.searchType == .name {
                        TextField("Type here to search meals", text: $viewModel.searchQuery)
                            .onChange(of: viewModel.searchQuery) { newValue, _ in
                                debounceSearch(query: viewModel.searchQuery)
                            }
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(20)
                    } else if viewModel.searchType == .letter{
                        Picker("Select a letter", selection: $viewModel.searchQuery) {
                            ForEach(alphabet, id: \.self) { letter in
                                Text(String(letter)).tag(String(letter))
                            }
                        }
                            .pickerStyle(.menu)
                            .padding()
                        Button(action: {
                            Task {
                                await viewModel.performSearch(query: viewModel.searchQuery)
                            }
                        }) {
                           RoundedRectangle(cornerRadius: 25.0)
                                .frame(width:20, height: 20)
                        }
                    }
                    List(viewModel.meals, id: \.id) { meal in
                        Button(action: {
                            chosenMeal = meal
                            routerState = 2
                        }) {
                            MealRow(meal:meal)
                        }
                    }

                }
        }
    }
    
    private func debounceSearch(query: String) {
            searchTimer?.invalidate()
            searchTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                Task {
                    await viewModel.performSearch(query: query)
                }
            }
        }
    
}
