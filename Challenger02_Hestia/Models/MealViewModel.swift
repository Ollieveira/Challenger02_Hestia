///Codigo do Guilherme

//import SwiftUI
//
//@MainActor
//class MealViewModel: ObservableObject {
//    @Published var meals: [Meal] = []
//    @Published var searchQuery: String = ""
//    @Published var searchType: SearchType = .name // Can be .name or .letter
//
//    enum SearchType {
//        case name, letter, category
//    }
//    
//    func performSearch(query: String) async {
//        guard !query.isEmpty else {
//            meals = []
//            return
//        }
//        
//        do {
//            let urlString: String
//            switch searchType {
//            case .name:
//                urlString = "https://www.themealdb.com/api/json/v1/1/search.php?s=\(query)"
//            case .letter:
//                guard query.count == 1 else { return }
//                urlString = "https://www.themealdb.com/api/json/v1/1/search.php?f=\(query)"
//            case .category:
//                urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(query)"
//            }
//            let fetchedMeals = try await WebService().fetchMeals(fromURL: urlString)
//            meals = fetchedMeals
//            print(meals)
//        } catch {
//            print("Failed to fetch meals: \(error)")
//        }
//    }
//}

/// Codigo atualizado Willys

//import SwiftUI
//
//@MainActor
//class MealViewModel: ObservableObject {
//    @Published var meals: [Meal] = []
//    @Published var oddMeals: [Meal] = []
//    @Published var evenMeals: [Meal] = []
//    @Published var searchQuery: String = ""
//    @Published var searchType: SearchType = .letter // Can be .name or .letter
//    @Published var isLoading = false
//
//
//    enum SearchType {
//        case name, letter, category
//    }
//    
//    func getAllMeals(for letter: Character) async {
//        isLoading = true
//        await performSearch(query: String(letter))
//        isLoading = false
//    }
//
//
//    func performSearch(query: String) async {
//        guard !query.isEmpty else {
//            meals = []
//            return
//        }
//        
//        do {
//            let urlString: String
//            switch searchType {
//            case .name:
//                urlString = "https://www.themealdb.com/api/json/v1/1/search.php?s=\(query)"
//            case .letter:
//                guard query.count == 1 else { return }
//                urlString = "https://www.themealdb.com/api/json/v1/1/search.php?f=\(query)"
//            case .category:
//                urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(query)"
//            }
//            let fetchedMeals = try await WebService().fetchMeals(fromURL: urlString)
//            for meal in fetchedMeals {
//                if !meals.contains(where: { $0.id == meal.id }) {
//                    meals.append(meal)
//                }
//            }
//            print("Fetch feita com:", query)
//        } catch {
//            print("Failed to fetch meals: \(error)")
//        }
//    }
//}

import SwiftUI

@MainActor
class MealViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var searchQuery: String = ""
    @Published var searchType: SearchType = .letter // Can be .name or .letter
    @Published var isLoading = false

    enum SearchType {
        case name, letter, category
    }
    
    func getAllMeals(for letter: Character) async {
        isLoading = true
        await performSearch(query: String(letter))
        isLoading = false
    }

    func performSearch(query: String) async {
        guard !query.isEmpty else {
            meals = []
            return
        }
        
        do {
            let urlString: String
            switch searchType {
            case .name:
                urlString = "https://www.themealdb.com/api/json/v1/1/search.php?s=\(query)"
            case .letter:
                guard query.count == 1 else { return }
                urlString = "https://www.themealdb.com/api/json/v1/1/search.php?f=\(query)"
            case .category:
                urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(query)"
            }
            let fetchedMeals = try await WebService().fetchMeals(fromURL: urlString)
            for meal in fetchedMeals {
                if !meals.contains(where: { $0.id == meal.id }) {
                    meals.append(meal)
                }
            }
            print("Fetch feita com:", query)
        } catch {
            print("Failed to fetch meals: \(error)")
        }
    }
    

    func getMealType(for index: Int) -> Bool {
        return index % 2 == 0
    }
}
