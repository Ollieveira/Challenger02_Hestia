import SwiftUI

struct AddRecipeManually: View {
    @Environment(\.presentationMode) var presentationMode
    @State var viewModel: MealViewModel
    
    @State private var strMeal = ""
    @State private var strArea = ""
    @State private var strCategory = ""
    @State private var instructionSteps: [String] = [""]
//    @State private var strMealThumb = NSNull()
    @State private var strYoutube = ""
    @State private var notes = ""
    @State private var ingredients: [(key: String, value: String)] = [(key: "", value: "")]
    
    var isFormValid: Bool {
        !strMeal.isEmpty && !strArea.isEmpty && !instructionSteps.isEmpty && !ingredients.isEmpty && !ingredients.contains { $0.key.isEmpty || $0.value.isEmpty }
    }
    
    var body: some View {
            Form {
                Section(header: Text("Detalhes da Receita")) {
                    TextField("Nome da Receita", text: $strMeal)
                    TextField("Localidade", text: $strArea)
//                    TextField("Receita Thumbnail URL", text: $strMealThumb)
                    TextField("YouTube URL", text: $strYoutube)
                    TextField("Anotações", text: $notes)
                }
                
                Section(header: Text("Passo a passo")) {
                    ForEach(0..<instructionSteps.count, id: \.self) { index in
                        HStack {
                            TextField("Instruções - Passo \(index + 1)", text: $instructionSteps[index])
                            if instructionSteps.count > 1 {
                                Button(action: {
                                    unfocusTextFields()
                                    if instructionSteps.indices.contains(index) {
                                        print(index)
                                        instructionSteps.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "minus.circle")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    Button(action: {
                        instructionSteps.append("")
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Adicionar Passo")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(.blue)
                }

                Section(header: Text("Ingredientes")) {
                    ForEach(0..<ingredients.count, id: \.self) { index in
                        HStack {
                            TextField("Ingrediente", text: Binding(
                                get: { ingredients[index].key },
                                set: { newKey in
                                    ingredients[index].key = newKey
                                }
                            ))
                            TextField("Medida", text: Binding(
                                get: { ingredients[index].value },
                                set: { newValue in
                                    ingredients[index].value = newValue
                                }
                            ))
                            if ingredients.count > 1 {
                                Button(action: {
                                    unfocusTextFields()

                                    if ingredients.indices.contains(index) {
                                        ingredients.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "minus.circle")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    Button(action: {
                        ingredients.append((key: "", value: ""))
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Adicionar Ingrediente")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(.blue)
                }

                
                
                Section {
                    Button(action: saveMeal) {
                        Text("Salvar Receita")
                            .font(.title3)
                            .fontDesign(.rounded)
                            .foregroundStyle(self.isFormValid ? Color.tabViewCor : Color.gray)
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(self.strMeal.isEmpty || self.strArea.isEmpty || self.instructionSteps.isEmpty || self.ingredients.isEmpty)
                }
            }
        
        .navigationTitle("Adicione sua Receita")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Salvar") {
                    saveMeal()
                }
                .disabled(!self.isFormValid)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Voltar") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        
    }
    
    
    private func unfocusTextFields() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil
        )
    }
    
    func saveMeal() {
        let ingredientsArray = ingredients.filter { !$0.key.isEmpty && !$0.value.isEmpty }
            .map { Meal.Ingredient(quantidade: $0.value, ingrediente: $0.key) }

        // Coleta os dados do usuário
        let mealData: [String: Any] = [
            "strMeal": strMeal,
            "area": strArea,
            "categoria": strCategory.isEmpty ? "Default Category" : strCategory,
            "strInstructions": instructionSteps.filter { !$0.isEmpty }.joined(separator: "\n"),
//            "strMealThumb": strMealThumb.isEmpty ? NSNull() : strMealThumb as Any,  // Conversão explícita para Any ou NSNull
            "strYoutube": strYoutube.isEmpty ? "https://www.youtube.com/watch?v=dQw4w9WgXcQ" : strYoutube,
            "notes": notes,
            // Aqui você adiciona os ingredientes e medidas como um dicionário de [String: String]
            "ingredientes": ingredientsArray.map { ["quantidade": $0.quantidade, "ingrediente": $0.ingrediente] }
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
struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeManually(viewModel: MealViewModel.instance)
    }
}
