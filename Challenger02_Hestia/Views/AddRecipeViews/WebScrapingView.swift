//
//  WebScrappingView.swift
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
    @State private var retryCount = 0
    private let maxRetryCount = 3

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
            } else {
                ScrollView {
                    Text("Response: \(responseString)")
                }
            }

            TextField("Enter URL here", text: $selectedUrl)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Extract Text from URL") {
                extractTextFromURL()
            }

            Button("Simplify Text") {
                sendRequest1(with: responseString)
            }

            Button("Create JSON") {
                sendRequest2(with: responseString)
            }
        }
        .padding()
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
            
            // This will print the actual JSON string that is being decoded
            print("Nested JSON Data: \(jsonResponse.text)")

            if let nestedJsonData = jsonResponse.text.data(using: .utf8) {
                do {
                    let mealData = try JSONSerialization.jsonObject(with: nestedJsonData, options: []) as? [String: Any]
                    if let mealDict = mealData?["Meal"] as? [String: Any] {
                        let finalMealData = try JSONSerialization.data(withJSONObject: mealDict)
                        let meal = try decoder.decode(Meal.self, from: finalMealData)
                        print("Decoded Meal:", meal)
                        viewModel.addToFavorites(meal: meal)
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
                    } else {
                        self.responseString = "Failed to fetch HTML"
                    }
                }
            }.resume()
        }

        func parseHTML(_ html: String, retryCount: Int) {
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

    func sendRequest1(with text: String) {
        guard let requestURL = URL(string: "https://hestiarecipes.netlify.app/.netlify/functions/recipeGPT") else { return }
        let formattedPrompt = """
        Retire as partes desse texto quew contem ads e comentarios, alem das partes nao ligadas diretamente a principal receita.
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
                    }
                } else {
                    self.responseString = "Failed to send request or parse response"
                }
            }
        }.resume()
    }

    func sendRequest2(with text: String) {
        guard let requestURL = URL(string: "https://hestiarecipes.netlify.app/.netlify/functions/recipeGPT") else { return }
        let formattedPrompt = """
        Analise o seguinte texto contendo informações sobre uma receita misturadas com comentários e anúncios. Extraia as informações relevantes apenas para a receita de forma pratica e direta e estruture-as no seguinte formato JSON: O objeto 'Meal' deve conter os campos 'idMeal' (nil), 'strMeal' (nome da receita), 'strCategory' (categoria, como sobremesa ou salgado), 'strArea' (origem geográfica da receita, caso não ache, coloque mundo), 'strInstructions' (instrucao completa de como fazer a receita no sentido de acoes na cozinha, com cada grande passo dividido por ponto, nunca coloque numeros como 1, 2 para controlar a ordem apenas o passo em si), 'instructionSteps' (nil), 'strMealThumb' (nil), 'strTags' (nil), 'strYoutube' (nil), 'notes' (nil), e 'ingredients' (um dicionário com os ingredientes e suas quantidades. Caso nao ache quantidade, coloque "A gosto", evitando ao maximo fazer isso). Ignorar qualquer conteúdo não relevante para a receita e focar apenas nos detalhes da receita. Texto:

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
                        self.decodeMeal(from: responseString)  // Atualizado para decodificar corretamente
                    }
                } else {
                    self.responseString = "Failed to send request or parse response"
                }
            }
        }.resume()
    }
}

struct WebScrapingView_Previews: PreviewProvider {
    static var previews: some View {
        WebScrapingView()
    }
}
