import SwiftUI
import Combine

@MainActor
class CategoryViewModel: ObservableObject {
    @Published var meals: [MealIncomplete] = []
    @Published var categories: [Category] = []
    @Published var selectedCategory: Category? {
        didSet {
            Task {
                await loadMealsForCategory()
            }
        }
    }

    init() {
        Task {
            await loadCategories()
        }
    }

    func loadCategories() async {
        do {
            categories = try await WebService().fetchCategories()
        } catch {
            print("Failed to fetch categories: \(error)")
        }
    }

    func loadMealsForCategory() async {
        guard let category = selectedCategory,
              let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(selectedCategory!.strCategory)") else { return }

        do {
            meals = try await WebService().fetchMealsCategory(fromURL: url.absoluteString)
        } catch {
            print("Failed to fetch meals for category \(category): \(error)")
        }
    }
}
