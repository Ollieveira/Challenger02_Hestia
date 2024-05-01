import Foundation

class WebService {
    
    enum NetworkError: Error {
        case badUrl
        case invalidRequest
        case badResponse
        case badStatus
        case failedToDecodeResponse
    }
    
    func fetchMeals(fromURL urlString: String) async throws -> [Meal] {
        guard let url = URL(string: urlString) else { throw NetworkError.badUrl }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("HTTP Error: Status code is not 200")
            throw NetworkError.badResponse
        }

        do {
            let mealsResponse = try JSONDecoder().decode(MealsResponse.self, from: data)
            return mealsResponse.meals
        } catch {
            print("Decoding Error: \(error)")
            throw NetworkError.failedToDecodeResponse
        }
    }
    
    func fetchCategories() async throws -> [Category] {
        let urlString = "https://www.themealdb.com/api/json/v1/1/categories.php"
        guard let url = URL(string: urlString) else { throw NetworkError.badUrl }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedResponse = try JSONDecoder().decode(CategoriesResponse.self, from: data)
        return decodedResponse.categories
    }
    
    func fetchMealsCategory(fromURL urlString: String) async throws -> [MealIncomplete] {
        guard let url = URL(string: urlString) else { throw NetworkError.badUrl }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("HTTP Error: Status code is not 200")
            throw NetworkError.badResponse
        }

        do {
            let mealsResponse = try JSONDecoder().decode(CategoriesMealsResponse.self, from: data)
            return mealsResponse.meals
        } catch {
            print("Decoding Error: \(error)")
            throw NetworkError.failedToDecodeResponse
        }
    }
    
}
