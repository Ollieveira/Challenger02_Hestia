import SwiftUI
import CodableExtensions

@Observable
class MealViewModel {
    static var instance = MealViewModel()
    static let alphabet = "abcdefghijklmnoprstvwy" // Retiramos q u x z
    var searchType: SearchType = .letter
    
    var meals: [Meal] = [] // Cache inicial de receitas carregadas e salvas localmente
    var filteredMeals: [Meal] { // Refeições filtradas para exibição
        self.meals.filter { meal in
            let hasRestriction = meal.dietaryRestrictions.contains { activeFilters.contains($0) }
            if searchInput.isEmpty {
                return hasRestriction == false
            } else {
                return hasRestriction == false && meal.strMeal.localizedCaseInsensitiveContains(searchInput)
            }
        }
    }
    
    var filteredFavoriteMeals: [Meal] { // Refeições filtradas para exibição
        self.favoriteMeals.filter { meal in
            let hasRestriction = meal.dietaryRestrictions.contains { activeFilters.contains($0) }
            if searchInput.isEmpty {
                return hasRestriction == false
            } else {
                return hasRestriction == false && meal.strMeal.localizedCaseInsensitiveContains(searchInput)
            }
        }
    }

    
    var favoriteMeals: [Meal] = [] // Refeições favoritas
    
    var activeFilters: Set<String> = []
    var searchInput: String = ""
    
    var isLoading = false
    
    enum SearchType {
        case name, letter, category
    }
    
    private init() {
        loadAllMeals()
        loadFavoriteMeals()
    }
    
    func saveMealNotes(_ meal: Meal, notes: String) {
        if let index = meals.firstIndex(where: { $0.id == meal.id }) {
            meals[index].notes = notes
            saveMeals()
        }
        if let index = favoriteMeals.firstIndex(where: { $0.id == meal.id }) {
            favoriteMeals[index].notes = notes
            saveMeals()
        }
    }
    
    func saveMeals() {
        do {
            try meals.save(in: "meals")
            try favoriteMeals.save(in: "favoriteMeals")
            print("Meals saved")
        } catch {
            print("Failed to save meals: \(error)")
        }
    }
    
    func loadAllMeals() {
        if let loadedMeals = try? [Meal].load(from: "meals"), !loadedMeals.isEmpty {
            self.meals = loadedMeals
            print("Using cached meals")
        } else {
            print("No cached meals found")
            self.meals = loadLocalMeals(from: "DataRecipesPortuguese")
        }
    }

    func loadFavoriteMeals() {
        if let loadedFavoriteMeals = try? [Meal].load(from: "favoriteMeals"), !loadedFavoriteMeals.isEmpty {
            self.favoriteMeals = loadedFavoriteMeals
            print("Using cached favorite meals")
        } else {
            print("No cached favorite meals found")
        }
    }

    
//    func getAllMeals(for letter: Character) async {
//        isLoading = true
//        await performSearch(query: String(letter))
//        isLoading = false
//    }
    
    public func filterMeals() {
//        if searchInput.isEmpty {
//            applyFilters()
//        } else {
//            filteredMeals = meals.filter { meal in
//                meal.strMeal.lowercased().contains(searchInput.lowercased())
//            }
//        }
    }
    
//    func performSearch(query: String) async {
//        guard !query.isEmpty else { return }
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
//            
//            await MainActor.run {
//                for meal in fetchedMeals {
//                    if !meals.contains(where: { $0.id == meal.id }) {
//                        meals.append(meal)
//                    }
//                }
////                filteredMeals = meals // Atualiza o cache inicial com todas as refeições
//                filterMeals()
//            }
//            
//            print("Fetch completed for:", query)
//        } catch {
//            print("Failed to fetch meals: \(error)")
//        }
//    }
    
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
//        if activeFilters.isEmpty {
//            filteredMeals = meals // Se não houver filtros, use todas as refeições carregadas
//        } else {
//            filteredMeals = meals.filter { meal in
//                !meal.dietaryRestrictions.contains(where: activeFilters.contains)
//            }
//        }
    }
    
    func addToFavorites(meal: Meal) -> Int? {
            print("Attempting to add meal:", meal)
            
            // Add to favorite meals if not already in the favorites list
            if !favoriteMeals.contains(where: { $0.id == meal.id }) {
                favoriteMeals.append(meal)
                print("Added to favorites.")
            } else {
                print("This ID already exists in favorites.")
            }
            
            // Add to main meals array if not already present
            if let existingIndex = meals.firstIndex(where: { $0.id == meal.id }) {
                print("Meal already exists in the main list.")
                saveMeals()
                return existingIndex
            } else {
                meals.append(meal)
                print("Meal added to main list because it was not already present.")
                saveMeals()
                return meals.firstIndex(where: { $0.id == meal.id })
            }
        }
    func removeFromFavorites(meal: Meal) {
        favoriteMeals.removeAll(where: { $0.id == meal.id })
        saveMeals()
    }
}
