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
//                ScrollView {
//                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
//                        ForEach(viewModel.meals.indices, id: \.self) { index in
//                            NavigationLink(
//                                destination: MealDetailView(meal: $viewModel.meals[index])
//                                    .toolbar(.hidden, for: .tabBar)
//                            ) {
//                                MealRow(meal: viewModel.meals[index], indexInGrid: index, isLeftColumn: index % 2 == 0)
//                            }
//                            .onAppear {
//                                if index == viewModel.meals.count - 1 {
//                                    // Load more meals if needed
//                                    if let lastMeal = viewModel.meals.last {
//                                        if let lastLetter = lastMeal.strMeal.first,
//                                           let nextLetterIndex = alphabet.firstIndex(of: lastLetter)?.advanced(by: 1),
//                                           nextLetterIndex < alphabet.count {
//                                            Task {
//                                                await viewModel.getAllMeals(for: alphabet[nextLetterIndex])
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    .padding(.horizontal, 16)
//                }
                ScrollView {
                    HStack(spacing: 20) {
                        LazyVStack (spacing:20){
                            ForEach(Array(viewModel.meals.indices.filter { $0 % 2 == 0 }), id: \.self) { index in
                                NavigationLink(
                                    destination: MealDetailView(meal: viewModel.meals[index])
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
                                        destination: MealDetailView(meal: viewModel.meals[index])
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




