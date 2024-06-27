import Foundation


struct Meal: Identifiable, Codable, Hashable {
    var id: String { idMeal }
    let idMeal: String
    let strMeal: String
    let categoria: String?
    let area: String?
    let strInstructions: String?
    let instructionSteps: [String]
    let strMealThumb: URL?
    let strTags: String?
    let strYoutube: URL?
    var notes: String?
    var ingredientes: [String: String]
    var dietaryRestrictions: [String]

    enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, categoria, area, strInstructions, strMealThumb, strTags, strYoutube, notes, ingredientes, instructionSteps, ingredients
    }

    struct Ingredient: Codable, Hashable {
        let quantidade: String
        let ingrediente: String
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        let idMealValue = try container.decodeIfPresent(String.self, forKey: .idMeal)
        idMeal = (idMealValue?.isEmpty ?? true) ? UUID().uuidString : idMealValue!
        categoria = try container.decodeIfPresent(String.self, forKey: .categoria)
        area = try container.decodeIfPresent(String.self, forKey: .area)
        strInstructions = try container.decodeIfPresent(String.self, forKey: .strInstructions)
        strMealThumb = try container.decodeIfPresent(URL.self, forKey: .strMealThumb)
        strTags = try container.decodeIfPresent(String.self, forKey: .strTags)
        strYoutube = try container.decodeIfPresent(URL.self, forKey: .strYoutube)
        notes = try container.decodeIfPresent(String.self, forKey: .notes)

        // Inicialize o dicionário de ingredientes vazio
        ingredientes = [:]

        // Decodificar ingredientes do formato novo (array de objetos)
        if let ingredientsArray = try container.decodeIfPresent([Ingredient].self, forKey: .ingredientes) {
            for ingredient in ingredientsArray {
                ingredientes[ingredient.ingrediente] = ingredient.quantidade
            }
        }
        
        // Decodificar ingredientes do formato antigo (dicionário)
        if let ingredientsDict = try container.decodeIfPresent([String: String].self, forKey: .ingredients) {
            ingredientes.merge(ingredientsDict) { (_, new) in new }
        }

        
        // Decodificar etapas de instrução
        if let instructionStepsArray = try container.decodeIfPresent([String].self, forKey: .instructionSteps) {
            // Se há um array de strings, usamos diretamente
            instructionSteps = instructionStepsArray
        } else if let strInstructions = strInstructions {
            var components: [String] = []
            
            // Verificar se há ocorrências de "\n" ou ". " e adicionar apenas o válido
            if strInstructions.contains("\n") {
                components = strInstructions.components(separatedBy: "\n")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
            } else if strInstructions.contains(". ") {
                components = strInstructions.components(separatedBy: ". ")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
            } else {
                // Se não houver separadores específicos, considerar como um único item
                components = [strInstructions]
            }
            
            instructionSteps = components
        } else {
            instructionSteps = []
        }

        // Determine dietary restrictions based on ingredients
        self.dietaryRestrictions = []
        self.dietaryRestrictions = determineDietaryRestrictions()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(idMeal, forKey: .idMeal)
        try container.encode(strMeal, forKey: .strMeal)
        try container.encode(categoria, forKey: .categoria)
        try container.encode(area, forKey: .area)
        try container.encode(strInstructions, forKey: .strInstructions)
        try container.encode(strMealThumb, forKey: .strMealThumb)
        try container.encode(strTags, forKey: .strTags)
        try container.encode(strYoutube, forKey: .strYoutube)
        try container.encode(notes, forKey: .notes)  // Codifica as anotações
        
        // Codificar ingredientes como um array de objetos
        let ingredientsArray = ingredientes.map { Ingredient(quantidade: $0.value, ingrediente: $0.key) }
        try container.encode(ingredientsArray, forKey: .ingredientes)
        
        // Encoder para instructionSteps
        try container.encode(instructionSteps, forKey: .instructionSteps)
    }



    private func determineDietaryRestrictions() -> [String] {
        var restrictions: [String] = []

        if ingredientes.keys.contains(where: DietaryRestrictionsData.nonDairyFreeIngredients.contains) {
            restrictions.append("Non-Dairy-Free")
        }
        if ingredientes.keys.contains(where: DietaryRestrictionsData.nonGlutenFreeIngredients.contains) {
            restrictions.append("Non-Gluten-Free")
        }
        if ingredientes.keys.contains(where: DietaryRestrictionsData.nonEggFreeIngredients.contains) {
            restrictions.append("Non-Egg-Free")
        }
        if ingredientes.keys.contains(where: DietaryRestrictionsData.nonVeganIngredients.contains) {
            restrictions.append("Non-Vegan")
        }
        if ingredientes.keys.contains(where: DietaryRestrictionsData.nonSeafoodFreeIngredients.contains) {
            restrictions.append("Non-Seafood-Free")
        }
        if ingredientes.keys.contains(where: DietaryRestrictionsData.nonPeanutFreeIngredients.contains) {
            restrictions.append("Non-Peanut-Free")
        }
        if ingredientes.keys.contains(where: DietaryRestrictionsData.nonSoyFreeIngredients.contains) {
            restrictions.append("Non-Soy-Free")
        }
        if ingredientes.keys.contains(where: DietaryRestrictionsData.nonSugarFreeIngredients.contains) {
            restrictions.append("Non-Sugar-Free")
        }

        return restrictions
    }
}

struct MealsResponse: Codable {
    let meals: [Meal]
}

//extension Meal {
//    func getInstructionSteps() -> [String] {
//        return strInstructions.components(separatedBy: "\r\n").filter { !$0.isEmpty }
//    }
//}

struct MealIncomplete: Identifiable, Codable {
    var id: String { idMeal }
    let idMeal: String
    let strMeal: String
    let strMealThumb: URL
}

struct CategoriesMealsResponse: Codable {
    let meals: [MealIncomplete]
}
