import SwiftUI
import Combine

struct MealsListView: View {
    @StateObject var viewModel = MealViewModel()
    @State private var searchTimer: Timer?
    let alphabet = Array("abcdefghijklmnopqrstuvwxyz")
    
    var body: some View {
        NavigationView {
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
                                debounceSearch(query: newValue)
                            }
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
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
                           RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                .frame(width:20, height: 20)
                        }
                    }
                    List(viewModel.meals, id: \.id) { meal in
                        NavigationLink(destination: MealDetailView(meal: meal)) {
                            MealRow(meal: meal)
                        }
                    }

                }
            }
            .navigationTitle("Meal Search")
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

struct MealsListView_Previews: PreviewProvider {
    static var previews: some View {
        MealsListView()
    }
}
