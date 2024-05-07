import Foundation

struct Meal: Identifiable, Codable, Equatable, Hashable {
    var ide = UUID() 
    var id: String { idMeal }
    let idMeal: String
    let strMeal: String
    let strCategory: String
    let strArea: String
    let strInstructions: String
    let instructionSteps: [String]
    let strMealThumb: URL
    let strTags: String?
    let strYoutube: URL?

    var ingredients: [String: String]

    enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strCategory, strArea, strInstructions, strMealThumb, strTags, strYoutube
    }

    enum DynamicCodingKeys: String, CodingKey {
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5,
             strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10,
             strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15,
             strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20,
             strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5,
             strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10,
             strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15,
             strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strCategory = try container.decode(String.self, forKey: .strCategory)
        strArea = try container.decode(String.self, forKey: .strArea)
        strInstructions = try container.decode(String.self, forKey: .strInstructions)
        strMealThumb = try container.decode(URL.self, forKey: .strMealThumb)
        strTags = try container.decodeIfPresent(String.self, forKey: .strTags)
        if let urlString = try container.decodeIfPresent(String.self, forKey: .strYoutube), let url = URL(string: urlString) {
            strYoutube = url
        } else {
            strYoutube = nil
        }

        instructionSteps = strInstructions
            .split(whereSeparator: { $0.isNewline || $0 == "." })
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var ingredientsDict = [String: String]()
        for i in 1...20 {
            let ingredientKey = DynamicCodingKeys(stringValue: "strIngredient\(i)")!
            let measureKey = DynamicCodingKeys(stringValue: "strMeasure\(i)")!
            if let ingredient = try dynamicContainer.decodeIfPresent(String.self, forKey: ingredientKey),
               let measure = try dynamicContainer.decodeIfPresent(String.self, forKey: measureKey),
               !ingredient.isEmpty {
                ingredientsDict[ingredient] = measure
            }
        }
        self.ingredients = ingredientsDict
    }
}

struct MealsResponse: Codable {
    let meals: [Meal]
}

extension Meal {
    func getInstructionSteps() -> [String] {
        return strInstructions.components(separatedBy: "\r\n").filter { !$0.isEmpty }
    }
}

struct MealIncomplete: Identifiable, Codable {
    var id: String { idMeal }
    let idMeal: String
    let strMeal: String
    let strMealThumb: URL
}

struct CategoriesMealsResponse: Codable {
    let meals: [MealIncomplete]
}
