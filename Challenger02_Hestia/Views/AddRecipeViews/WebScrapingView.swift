//
//  WebScrapingView.swift
//  Challenger02_Hestia
//
//  Created by Guilherme Avila on 02/06/24.
//

import SwiftUI
import SwiftSoup

struct JsonResponse: Codable {
    let text: String
}

struct WebScrapingView: View {
    @State var viewModel = MealViewModel.instance
    @State private var responseString = ""
    @State private var selectedUrl = ""
    @State private var isLoading = false
    @State private var navigateToDetail = false
    @State private var newMealIndex = 0
    @State private var retryCount = 0
    private let maxRetryCount = 3
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showConfirmationAlert = false
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Carregando...")
            } else {
                Spacer()
                TextField("Insira a URL aqui", text: $selectedUrl)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Spacer()
                Button(action: {
                    confirmSpendingCoin()
                }) {
                    Text("Confirmar")
                        .foregroundColor(.white)
                        .bold()
                        .font(.body)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.tabViewCor)
                                .shadow(radius: 5)
                        )
                }
                .padding()
            }
            
            NavigationResetView(
                destination: MealDetailView(meal: $viewModel.meals[newMealIndex]),
                isActive: $navigateToDetail
            )
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Alerta"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert(isPresented: $showConfirmationAlert) {
            Alert(
                title: Text("Confirmação"),
                message: Text("Certeza que quer gastar 2 moedas aqui?"),
                primaryButton: .default(Text("Confirmar")) {
                    executeRequest()
                },
                secondaryButton: .cancel()
            )
        }
    }

    func decodeMeal(from responseString: String) {
        guard let jsonData = responseString.data(using: .utf8) else {
            print("Error: Cannot create Data from responseString")
            return
        }

        let decoder = JSONDecoder()

        do {
            let jsonResponse = try decoder.decode(JsonResponse.self, from: jsonData)
            print("Decoded JsonResponse, extracting text: \(jsonResponse.text)")
            
            print("Nested JSON Data: \(jsonResponse.text)")

            if let nestedJsonData = jsonResponse.text.data(using: .utf8) {
                do {
                    let mealData = try JSONSerialization.jsonObject(with: nestedJsonData, options: []) as? [String: Any]
                    if let mealDict = mealData?["Meal"] as? [String: Any] {
                        let finalMealData = try JSONSerialization.data(withJSONObject: mealDict)
                        let meal = try decoder.decode(Meal.self, from: finalMealData)
                        print("Decoded Meal:", meal)
                        let mealIndex = viewModel.addToFavorites(meal: meal)
                        newMealIndex = mealIndex!
                        navigateToDetail = true
                        self.responseString = ""
                        self.selectedUrl = ""
                        
                    }
                } catch {
                    print("Error decoding Meal from nested JSON:", error)
                }
            }
            
        } catch {
            print("Error decoding JsonResponse:", error)
        }
    }

    func extractTextFromURL() {
        guard let url = URL(string: selectedUrl) else {
            responseString = "Invalid URL"
            return
        }

        isLoading = true
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let data = data, let htmlString = String(data: data, encoding: .utf8) {
                    self.parseHTML(htmlString, retryCount: 0)
                    print("tentando sendReques1 com:", responseString)
                    self.sendRequest2(with: responseString)
                } else {
                    self.responseString = "Failed to fetch HTML"
                }
            }
        }.resume()
    }

    func parseHTML(_ html: String, retryCount: Int) {
        self.isLoading = true
        do {
            let doc: Document = try SwiftSoup.parse(html)
            let bodyText = try doc.body()?.text() ?? "No body text found"

            if bodyText.count < 40 && retryCount < maxRetryCount {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.retryCount += 1
                    self.extractTextFromURL()
                }
            } else {
                responseString = bodyText
            }
        } catch Exception.Error(let type, let message) {
            if retryCount < maxRetryCount {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.retryCount += 1
                    self.extractTextFromURL()
                }
            } else {
                responseString = "Parsing error: \(type) \(message)"
            }
        } catch {
            if retryCount < maxRetryCount {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.retryCount += 1
                    self.extractTextFromURL()
                }
            } else {
                responseString = "An error occurred"
            }
        }
    }

    func sendRequest2(with text: String) {
        guard let requestURL = URL(string: "https://hestiarecipes.netlify.app/.netlify/functions/recipeGPT") else { return }
        let formattedPrompt = """
        Analise o seguinte texto contendo informações sobre uma receita misturadas com comentários e anúncios. Extraia as informações relevantes apenas para a receita de forma pratica e direta e estruture-as no seguinte formato JSON:  O objeto 'Meal' deve conter os campos 'idMeal' (null), 'strMeal' (nome da receita), 'strCategory' (categoria, como sobremesa ou salgado ou "geral", nunca null), 'strArea' (origem geográfica da receita ou mundo, nunca vazia), 'strInstructions' (instrucao completa de como fazer a receita com cada grande passo dividido por ponto, nunca numerados por ordem, apenas o passo do modo de preparo em si), 'instructionSteps' (null), 'strMealThumb' (null), 'strTags' (null), 'strYoutube' (null), 'notes' (null), e 'ingredients' (um dicionário com os ingredientes e suas quantidades. Caso nao ache quantidade, coloque "A gosto", evitando ao maximo fazer isso. Coloque todos os igredientes, mesmo que de partes diferentes da receita, em um mesmo dicionario, nunca deve haver varios dicionarios dentro de ingredients, apenas 1 unificado). Ignorar qualquer conteúdo não relevante para a receita e focar apenas nos detalhes da receita. Não esqueca das virgulas, é importante que todas as chaves aparecam, mesmo que com null, e todas devem estar DENTRO do objeto Meal, inclusive o dicionario de ingredientes. Texto:

        \(text)
        """
        let requestData = ["prompt": formattedPrompt]
        guard let finalBody = try? JSONSerialization.data(withJSONObject: requestData) else { return }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("gON0etItoAwdyGbA4jAte8o9Zcs7P", forHTTPHeaderField: "x-secret-key")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let data = data {
                    if let responseString = String(data: data, encoding: .utf8) {
                        self.responseString = responseString
                        print("Received JSON:", responseString)
                        self.decodeMeal(from: responseString)
                        if navigateToDetail {
                            PurchaseManager.shared.useCoins(2)
                        }
                    }
                } else {
                    self.responseString = "Failed to send request or parse response"
                    self.isLoading = false
                }
            }
        }.resume()
    }
    
    func confirmSpendingCoin() {
        if PurchaseManager.shared.coins >= 1 {
            showConfirmationAlert = true
        } else {
            alertMessage = "Você não tem moedas suficientes!"
            showAlert = true
        }
    }

    func executeRequest() {
        extractTextFromURL()
    }
}

struct WebScrapingView_Previews: PreviewProvider {
    static var previews: some View {
        WebScrapingView()
    }
}
