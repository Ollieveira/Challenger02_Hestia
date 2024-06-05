
import SwiftUI

struct AddRecipeManually: View {
    @Environment(\.presentationMode) var presentationMode
    @State var viewModel: MealViewModel
    
    @State private var strMeal = ""
    @State private var strArea = ""
    @State private var strCategory = ""
    @State private var instructionSteps: [String] = [""]
    @State private var strMealThumb = ""
    @State private var strYoutube = ""
    @State private var notes = ""
    @State private var ingredients: [(key: String, value: String)] = [(key: "", value: "")]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Meal Details")) {
                    TextField("Meal Name", text: $strMeal)
                    TextField("Area", text: $strArea)
                    TextField("Meal Thumbnail URL", text: $strMealThumb)
                    TextField("YouTube URL", text: $strYoutube)
                    TextField("Notes", text: $notes)
                }
                
                Section(header: Text("Step by Step")) {
                    
                    ForEach(0..<instructionSteps.count, id: \.self) { index in
                        TextField("Step \(index + 1)", text: $instructionSteps[index])
                    }
                    Button(action: {
                        instructionSteps.append("")
                    }) {
                        Text("Add Step")
                    }
                    
                }
                
                Section(header: Text("Ingredients")) {
                    ForEach(0..<ingredients.count, id: \.self) { index in
                        HStack {
                            TextField("Ingredient", text: Binding(
                                get: { ingredients[index].key },
                                set: { newKey in
                                    ingredients[index].key = newKey
                                }
                            ))
                            TextField("Measure", text: Binding(
                                get: { ingredients[index].value },
                                set: { newValue in
                                    ingredients[index].value = newValue
                                }
                            ))
                        }
                    }
                    Button(action: {
                        ingredients.append((key: "", value: ""))
                    }) {
                        Text("Add Ingredient")
                    }
                }
                
                Button(action: saveMeal) {
                    Text("Save Meal")
                }
            }
            .navigationTitle("Add New Meal")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    func saveMeal() {
        // Coleta os dados do usuário
        let mealData: [String: Any] = [
            "strMeal": strMeal,
            "strArea": strArea,
            "strCategory": strCategory.isEmpty ? "Default Category" : strCategory,
            "strInstructions": instructionSteps.filter { !$0.isEmpty }.joined(separator: ". "),
            "strMealThumb": strMealThumb.isEmpty ? "defaultRecipeImage" : strMealThumb,
            "strYoutube": strYoutube.isEmpty ? "https://www.youtube.com/watch?v=dQw4w9WgXcQ" : strYoutube,
            "notes": notes,
            // Aqui você adiciona os ingredientes e medidas como um dicionário de [String: String]
            "ingredients": Dictionary(uniqueKeysWithValues: ingredients.filter { !$0.key.isEmpty && !$0.value.isEmpty })
        ]

        // Codifica os dados coletados em JSON
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: mealData, options: [])
            // Aqui você pode usar jsonData para criar uma instância de Meal usando o Decoder
            let decoder = JSONDecoder()
            let meal = try decoder.decode(Meal.self, from: jsonData)
            // Agora você tem uma instância de Meal que pode ser usada conforme necessário
            viewModel.addToFavorites(meal: meal)
        } catch {
            print("Erro ao salvar a refeição: \(error)")
        }

        // Dismiss the view
        presentationMode.wrappedValue.dismiss()
    }
}

    
//    func saveMeal() {
//        let instructions = instructionSteps.filter { !$0.isEmpty }.joined(separator: ". ")
//        let ingredientsDict = Dictionary(uniqueKeysWithValues: ingredients.filter { !$0.key.isEmpty && !$0.value.isEmpty })
//        
//        let newMeal = Meal(
//            idMeal: UUID().uuidString,
//            strMeal: strMeal,
//            strCategory: "",
//            strArea: strArea.isEmpty ? nil : strArea,
//            strInstructions: instructions,
//            instructionSteps: instructionSteps.filter { !$0.isEmpty },
//            strMealThumb: strMealThumb.isEmpty ? nil : URL(string: strMealThumb),
//            strTags: "",
//            strYoutube: strYoutube.isEmpty ? nil : URL(string: strYoutube),
//            notes: notes.isEmpty ? nil : notes,
//            ingredients: ingredientsDict
//        )
//        
//        viewModel.addToFavorites(meal: newMeal)
//        presentationMode.wrappedValue.dismiss()
//    }
//}

struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeManually(viewModel: MealViewModel.instance)
    }
}
