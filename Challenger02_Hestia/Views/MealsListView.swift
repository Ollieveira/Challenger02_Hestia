import SwiftUI
import Combine

struct MealsListView: View {
    @Binding var router: Router
    @Binding var chosenMeal: Meal?
    
    @StateObject var viewModel = MealViewModel()
    @State private var searchTimer: Timer?
    let alphabet = Array("abcdefghijklmnopqrstuvwxyz")
    
    var body: some View {
            VStack {
//                Picker("Search Type", selection: $viewModel.searchType) {
//                    Text("Name").tag(MealViewModel.SearchType.name)
//                    Text("Letter").tag(MealViewModel.SearchType.letter)
//                    Text("Category").tag(MealViewModel.SearchType.category)
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .padding()
//                
//                if viewModel.searchType == .category {
//                    CategoryListView()
//                } else {
//                    if viewModel.searchType == .name {
//                        TextField("Type here to search meals", text: $viewModel.searchQuery)
//                            .onChange(of: viewModel.searchQuery) { newValue, _ in
//                                debounceSearch(query: viewModel.searchQuery)
//                            }
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .padding(20)
//                    } else if viewModel.searchType == .letter{
//                        Picker("Select a letter", selection: $viewModel.searchQuery) {
//                            ForEach(alphabet, id: \.self) { letter in
//                                Text(String(letter)).tag(String(letter))
//                            }
//                        }
//                            .pickerStyle(.menu)
//                            .padding()
//                        Button(action: {
//                            Task {
//                                await viewModel.performSearch(query: viewModel.searchQuery)
//                            }
//                        }) {
//                           RoundedRectangle(cornerRadius: 25.0)
//                                .frame(width:20, height: 20)
//                        }
//                    }
                    
                    ScrollView {
                        HStack(alignment: .center, spacing: 26) {
                            VStack (){
                                LazyVStack(alignment: .trailing) {
                                    ForEach(Array(viewModel.meals.indices.filter { $0 % 2 == 0 }), id: \.self) { index in
                                        let meal = viewModel.meals[index]
                                        Button(action: {
                                            chosenMeal = meal
                                            router = .mealDetailView
                                        }) {
                                        MealRow(meal: meal, indexInGrid: index, isLeftColumn: true)
                                        }
                                        .onAppear {
                                            if index >= viewModel.meals.count - 3{
                                                let nextLetter = alphabet.first(where: { String($0) > viewModel.searchQuery })
                                                viewModel.searchQuery = String(nextLetter ?? "a")
                                                Task {
                                                    await viewModel.getAllMeals(for: nextLetter ?? "a")
                                                }
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                            }
                            VStack{
                                LazyVStack(alignment: .leading) {
                                    ForEach(Array(viewModel.meals.indices.filter { $0 % 2 != 0 }), id: \.self) { index in
                                        let meal = viewModel.meals[index]
                                        Button(action: {
                                            chosenMeal = meal
                                            router = .mealDetailView
                                        }) {
                                            MealRow(meal: meal, indexInGrid: index, isLeftColumn: false)
                                        }
                                        .onAppear {
                                            if index >= viewModel.meals.count - 3{
                                                let nextLetter = alphabet.first(where: { String($0) > viewModel.searchQuery })
                                                viewModel.searchQuery = String(nextLetter ?? "a")
                                                Task {
                                                    await viewModel.getAllMeals(for: nextLetter ?? "a")
                                                }
                                            }
                                        }
                                    }
                                }
                                Spacer()
                            }
                            
                            
                            if viewModel.isLoading {
                                ProgressView()
                            }
                        }
                        //.padding(.horizontal)
                    }


//                    ScrollView {
//                        HStack(spacing: 20) {
//                            VStack (spacing:20){
//                                // Filter first, then enumerate to reset the offset based on filtered results
//                                ForEach(Array(viewModel.meals.enumerated().filter { $0.offset % 2 == 0 }.map { $0.element }.enumerated()), id: \.element.id) { index, meal in
//                                    Button(action: {
//                                        chosenMeal = meal
//                                        router = .mealDetailView
//                                    }) {
//                                        MealRow(meal: meal, indexInGrid: index, isLeftColumn: true)
//                                    }
//                                }
//                                Spacer()
//                            }
//                            VStack (spacing: 20) {
//                                // Similar filtering and enumerating for another condition or the same, depending on layout needs
//                                ForEach(Array(viewModel.meals.enumerated().filter { $0.offset % 2 != 0 }.map { $0.element }.enumerated()), id: \.element.id) { index, meal in
//                                    Button(action: {
//                                        chosenMeal = meal
//                                        router = .mealDetailView
//                                    }) {
//                                        MealRow(meal: meal, indexInGrid: index, isLeftColumn: false)
//                                    }
//                                }
//                                Spacer()
//                            }
//                        }
//                        .padding(.horizontal)
//                    }

                }
            .onAppear {
                viewModel.searchQuery = "a"
                Task {
                    await viewModel.getAllMeals(for: "a")
                }
            }

        }
    }
    
//    private func debounceSearch(query: String) {
//            searchTimer?.invalidate()
//            searchTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
//                Task {
//                    await viewModel.performSearch(query: query)
//                }
//            }
//        }
    

