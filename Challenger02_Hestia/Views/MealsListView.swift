//import SwiftUI
//import Combine
//
//struct MealsListView: View {
//    @Binding var router: Router
//    @Binding var chosenMeal: Meal?
//    
//    @StateObject var viewModel = MealViewModel()
//    @State private var searchTimer: Timer?
//    let alphabet = Array("abcdefghijklmnoprstvwy")  //Retiramos q u x z
//    @State var currentLetterIndex:Int = 0
//    
//    var body: some View {
//            VStack {
//                    ScrollView {
//                        HStack(alignment: .center, spacing: 20) {
//                            VStack (){
//                                LazyVStack(alignment: .trailing) {
//                                    ForEach(Array(viewModel.meals.indices.filter { $0 % 2 == 0 }), id: \.self) { index in
//                                        let meal = viewModel.meals[index]
//                                        Button(action: {
//                                            chosenMeal = meal
//                                            router = .mealDetailView
//                                        }) {
//                                        MealRow(meal: meal, indexInGrid: index, isLeftColumn: true)
//                                        }
//                                        .onAppear {
//                                            print("Meal da esquerda index: \(index), meal: \(meal.strMeal)")
//                                            if index == viewModel.meals.count - 2{
////                                                let nextLetter = alphabet.first(where: { String($0) > viewModel.searchQuery })
////                                                viewModel.searchQuery = String(nextLetter ?? "a")
////                                                Task {
////                                                    await viewModel.getAllMeals(for: nextLetter ?? "a")
////                                                }
//                                                print("Fazendo requisicao esquerda para letra \(alphabet[currentLetterIndex])")
//                                                currentLetterIndex += 1
//                                                if currentLetterIndex <= 25 {
//                                                    viewModel.searchQuery = String(alphabet[currentLetterIndex])
//                                                    Task {
//                                                        await viewModel.getAllMeals(for: alphabet[currentLetterIndex])
//                                                    }
//                                                }
//                                            }
//                                        }
//                                    }
//                                    Spacer()
//                                }
//                            }
//                            VStack{
//                                LazyVStack(alignment: .leading) {
//                                    ForEach(Array(viewModel.meals.indices.filter { $0 % 2 != 0 }), id: \.self) { index in
//                                        let meal = viewModel.meals[index]
//                                        Button(action: {
//                                            chosenMeal = meal
//                                            router = .mealDetailView
//                                        }) {
//                                            MealRow(meal: meal, indexInGrid: index, isLeftColumn: false)
//                                        }
//                                        .onAppear {
//                                            print("Meal da direita index: \(index), meal: \(meal.strMeal)")
//                                            if index == viewModel.meals.count - 2{
//                                                
//                                                //let nextLetter = alphabet.first(where: { String($0) > viewModel.searchQuery })
//                                                print("Fazendo requisicao direita para letra \(alphabet[currentLetterIndex])")
//                                                currentLetterIndex += 1
//                                                if currentLetterIndex <= 21 {
//                                                    viewModel.searchQuery = String(alphabet[currentLetterIndex])
//                                                    Task {
//                                                        await viewModel.getAllMeals(for: alphabet[currentLetterIndex])
//                                                    }
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//                                Spacer()
//                            }
//                            if viewModel.isLoading {
//                                ProgressView()
//                            }
//                        }
//                    }
//                }
//            .onAppear {
//                viewModel.searchQuery = "a"
//                Task {
//                    await viewModel.getAllMeals(for: "a")
//                }
//            }
//
//        }
//    }
 
import SwiftUI
import WaterfallGrid

struct MealsListView: View {
    @StateObject var viewModel = MealViewModel()
    let alphabet = Array("abcdefghijklmnoprstvwy") // Retiramos q u x z
    @State var currentLetterIndex: Int = 0

    var body: some View {
            VStack {
                ScrollView {
                    WaterfallGrid(viewModel.meals.indices, id: \.self) { index in
                        NavigationLink(
                            destination: MealDetailView(meal: $viewModel.meals[index]),
                            label: {
                                MealRow(meal: viewModel.meals[index], indexInGrid: index, isLeftColumn: viewModel.getMealType(for: index))
                            }
                        )
                        .onAppear {
                            if index == viewModel.meals.count - 1 && currentLetterIndex < alphabet.count {
                                loadMoreMeals()
                            }
                        }
                    }
                    .gridStyle(
                        columnsInPortrait: 2,
                        columnsInLandscape: 3,
                        spacing: 16 // Defina o espaçamento horizontal desejado aqui
                    )
                    .padding(.horizontal, 16)
                }
            }
            .padding(.top, 32)
        .onAppear {
            if viewModel.meals.isEmpty {
                loadMoreMeals()
            }
        }
    }

    func loadMoreMeals() {
        if currentLetterIndex < alphabet.count {
            viewModel.searchQuery = String(alphabet[currentLetterIndex])
            Task {
                await viewModel.getAllMeals(for: alphabet[currentLetterIndex])
                currentLetterIndex += 1
            }
        }
    }
}




