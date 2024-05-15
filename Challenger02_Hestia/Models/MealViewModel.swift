import SwiftUI
import CodableExtensions

@Observable
class MealViewModel: ObservableObject {
    static var instance = MealViewModel()
    static let alphabet = "abcdefghijklmnoprstvwy" // Retiramos q u x z
    var searchType: SearchType = .letter
    var meals: [Meal] = []
    var allMeals: [Meal] = []
    var favoriteMeals: [Meal] = [] // Adicione esta linha
    var activeFilters: Set<String> = []
    var isLoading = false
    
    enum SearchType {
        case name, letter, category
    }
    
    
    private init() {
        if let loadedMeals = try? [Meal].load(from: "meals"), !loadedMeals.isEmpty {
            self.meals = loadedMeals
            self.allMeals = self.meals
            print("Using cached meals")
        } else {
            print("No cached meals found")
        }
        if let loadedFavoriteMeals = try? [Meal].load(from: "favoriteMeals"), !loadedFavoriteMeals.isEmpty {
            self.favoriteMeals = loadedFavoriteMeals
            print("Using cached favorite meals")
        } else {
            print("No cached favorite meals found")
        }
    }
    
    
    
    func loadAllMeals() {
        Task {
            for letter in Self.alphabet {
                await getAllMeals(for: letter)
            }
        }
    }
    
    func getAllMeals(for letter: Character) async {
        isLoading = true
        await performSearch(query: String(letter))
        isLoading = false
        allMeals = meals
    }
    
    func performSearch(query: String) async {
        guard !query.isEmpty else { return }
        
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
            
            await MainActor.run {
                // Update meals array with new data
                for meal in fetchedMeals {
                    if !meals.contains(where: { $0.id == meal.id }) {
                        meals.append(meal)
                    }
                }
            }
            
            
            print("Fetch completed for:", query)
        } catch {
            print("Failed to fetch meals: \(error)")
        }
    }
    
    func getMealType(for index: Int) -> Bool {
        return index % 2 == 0
    }
    
    func addFilter(restriction: String) {
        activeFilters.insert(restriction)
        applyFilters()
    }
    
    func removeFilter(restriction: String) {
        activeFilters.remove(restriction)
        applyFilters()
    }
    
    func removeAllFilters() {
        activeFilters.removeAll()
        applyFilters()
    }
    
    private func applyFilters() {
        isLoading = true
        if activeFilters.isEmpty {
            meals = allMeals
        } else {
            meals = allMeals.filter { meal in
                !meal.dietaryRestrictions.contains(where: activeFilters.contains)
            }
        }
        isLoading = false
        print(self.meals)
    }
    
    func addToFavorites(meal: Meal) {
        if !favoriteMeals.contains(where: { $0.id == meal.id }) {
            favoriteMeals.append(meal)
            
            
        }
    }
    
    func removeFromFavorites(meal: Meal) {
        favoriteMeals.removeAll(where: { $0.id == meal.id })
        
        
    }
    
}

    
    

