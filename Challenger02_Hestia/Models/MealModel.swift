import Foundation


struct Meal: Identifiable, Codable, Hashable {
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
    var dietaryRestrictions: [String]

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
        strYoutube = try container.decodeIfPresent(String.self, forKey: .strYoutube).flatMap(URL.init)

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

        // Determine dietary restrictions based on ingredients
        self.dietaryRestrictions = []
        self.dietaryRestrictions = determineDietaryRestrictions()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(idMeal, forKey: .idMeal)
        try container.encode(strMeal, forKey: .strMeal)
        try container.encode(strCategory, forKey: .strCategory)
        try container.encode(strArea, forKey: .strArea)
        try container.encode(strInstructions, forKey: .strInstructions)
        try container.encode(strMealThumb, forKey: .strMealThumb)
        try container.encode(strTags, forKey: .strTags)
        try container.encode(strYoutube, forKey: .strYoutube)

        var dynamicContainer = encoder.container(keyedBy: DynamicCodingKeys.self)
        let ingredientsArray = Array(ingredients.keys)
        let measuresArray = Array(ingredients.values)
        for i in 0..<ingredients.count {
            let ingredientKey = DynamicCodingKeys(stringValue: "strIngredient\(i+1)")!
            let measureKey = DynamicCodingKeys(stringValue: "strMeasure\(i+1)")!
            try dynamicContainer.encode(ingredientsArray[i], forKey: ingredientKey)
            try dynamicContainer.encode(measuresArray[i], forKey: measureKey)
        }
    }


    private func determineDietaryRestrictions() -> [String] {
        var restrictions: [String] = []

        if ingredients.keys.contains(where: DietaryRestrictionsData.nonDairyFreeIngredients.contains) {
            restrictions.append("Non-Dairy-Free")
        }
        if ingredients.keys.contains(where: DietaryRestrictionsData.nonGlutenFreeIngredients.contains) {
            restrictions.append("Non-Gluten-Free")
        }
        if ingredients.keys.contains(where: DietaryRestrictionsData.nonEggFreeIngredients.contains) {
            restrictions.append("Non-Egg-Free")
        }
        if ingredients.keys.contains(where: DietaryRestrictionsData.nonVeganIngredients.contains) {
            restrictions.append("Non-Vegan")
        }
        if ingredients.keys.contains(where: DietaryRestrictionsData.nonSeafoodFreeIngredients.contains) {
            restrictions.append("Non-Seafood-Free")
        }
        if ingredients.keys.contains(where: DietaryRestrictionsData.nonPeanutFreeIngredients.contains) {
            restrictions.append("Non-Peanut-Free")
        }
        if ingredients.keys.contains(where: DietaryRestrictionsData.nonSoyFreeIngredients.contains) {
            restrictions.append("Non-Soy-Free")
        }
        if ingredients.keys.contains(where: DietaryRestrictionsData.nonSugarFreeIngredients.contains) {
            restrictions.append("Non-Sugar-Free")
        }

        return restrictions
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
