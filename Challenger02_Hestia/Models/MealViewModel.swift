import SwiftUI

@MainActor
class MealViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var searchQuery: String = ""
    @Published var searchType: SearchType = .name // Can be .name or .letter

    enum SearchType {
        case name, letter, category
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
            meals = fetchedMeals
            print(meals)
        } catch {
            print("Failed to fetch meals: \(error)")
        }
    }
}
