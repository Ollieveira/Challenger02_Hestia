import SwiftUI
import Vision
import UIKit
import CropViewController

struct OCRView: View {
    @State var viewModel = MealViewModel.instance
    @State private var responseString = ""
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var croppedImage: UIImage?
    @State private var extractedText = ""
    @State private var showCamera = false
    @State private var isEditingText = false
    @State private var editableText = ""
    @State private var isLoading = false
    @State private var showCropper = false
    @State private var navigateToDetail = false
    @State private var newMealIndex = 0
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showConfirmationAlert = false

    var body: some View {
        GeometryReader { geometry in
            VStack {
                if isLoading {
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            ProgressView("Processando")
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.tabViewCor))
                                .scaleEffect(2)
                            Spacer()
                        }
                        Spacer()
                    }
                } else {
                    if inputImage == nil {
                        HStack {
                            Spacer()
                            Button {
                                showImagePicker = true
                            } label: {
                                RoundedButtonView(
                                    imageName: "photo.fill",
                                    title: "Galeria",
                                    backgroundColor: Color.bgFavCardCor,
                                    iconColor: Color.tabViewCor,
                                    width: geometry.size.width / 2.5,
                                    custo: nil,
                                    receitokens: nil
                                )
                            }
                            .sheet(isPresented: $showImagePicker) {
                                ImagePicker(image: $inputImage)
                                    .onDisappear {
                                        if inputImage != nil {
                                            showCropper = true
                                        }
                                    }
                            }
                            Spacer()
                            Button {
                                showCamera = true
                            } label: {
                                RoundedButtonView(
                                    imageName: "camera.aperture",
                                    title: "Camera",
                                    backgroundColor: Color.bgFavCardCor,
                                    iconColor: Color.tabViewCor,
                                    width: geometry.size.width / 2.5,
                                    custo: nil,
                                    receitokens: nil
                                )
                            }
                            .sheet(isPresented: $showCamera) {
                                CameraView(image: $inputImage)
                                    .onDisappear {
                                        if inputImage != nil {
                                            showCropper = true
                                        }
                                    }
                            }
                            Spacer()
                        }
                    } else if inputImage != nil && extractedText.isEmpty {
                        if showCropper {
                            ImageCropperView(image: $inputImage, croppedImage: $croppedImage, showCropper: $showCropper)
                        } else if let croppedImage = croppedImage {
                            HStack {
                                Spacer()
                                VStack {
                                    Spacer()
                                    Image(uiImage: croppedImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 350)
                                    Button(action: {
                                        performOCR(on: croppedImage)
                                    }) {
                                        Text("Extract Text from Image")
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
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                    }
                    if !extractedText.isEmpty {
                        HStack {
                            Spacer()
                            VStack {
                                if let croppedImage = croppedImage {
                                    Image(uiImage: croppedImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                }

                                VStack(alignment: .leading) {
                                    Text("Extracted Text:")
                                    ZStack {
                                        TextEditor(text: $extractedText)
                                            .padding()
                                            .frame(height: 400)
                                        if !isEditingText {
                                            HStack {
                                                Spacer()
                                                Button(action: {
                                                    isEditingText.toggle()
                                                    editableText = extractedText
                                                }) {
                                                    Image(systemName: "pencil")
                                                        .padding(8)
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding()
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
                            Spacer()
                        }
                    }
                    Spacer()
                }
                NavigationResetView(
                    destination: MealDetailView(meal: $viewModel.meals[newMealIndex]),
                    isActive: $navigateToDetail
                )
            }
            .padding()
        }
        .background(Color.backgroundCor)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Alerta"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $showConfirmationAlert) {
            Alert(
                title: Text("Confirmação"),
                message: Text("Certeza que quer gastar 1 moeda aqui?"),
                primaryButton: .default(Text("Confirmar")) {
                    executeRequest()
                },
                secondaryButton: .cancel()
            )
        }
    }

    func performOCR(on image: UIImage) {
        guard let cgImage = image.cgImage else {
            return
        }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            if let observations = request.results as? [VNRecognizedTextObservation] {
                let recognizedStrings = observations.compactMap { $0.topCandidates(1).first?.string }
                DispatchQueue.main.async {
                    self.extractedText = recognizedStrings.joined(separator: "\n")
                    self.responseString = self.extractedText
                }
            }
        }

        do {
            try requestHandler.perform([request])
        } catch {
            print("Failed to perform OCR: \(error.localizedDescription)")
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

            if let nestedJsonData = jsonResponse.text.data(using: .utf8) {
                do {
                    let mealData = try JSONSerialization.jsonObject(with: nestedJsonData, options: []) as? [String: Any]
                    if let mealDict = mealData?["Meal"] as? [String: Any] {
                        let finalMealData = try JSONSerialization.data(withJSONObject: mealDict)
                        let meal = try decoder.decode(Meal.self, from: finalMealData)
                        print("Decoded Meal:", meal)
                        let mealIndex = viewModel.addToFavorites(meal: meal)
                        newMealIndex = mealIndex!
                        inputImage = nil
                        extractedText = ""
                        navigateToDetail = true

                    }
                } catch {
                    print("Error decoding Meal from nested JSON:", error)
                }
            }

        } catch {
            print("Error decoding JsonResponse:", error)
        }
    }

    func sendRequest2(with text: String) {
        self.isLoading = true
        guard let requestURL = URL(string: "https://hestiarecipes.netlify.app/.netlify/functions/recipeGPT") else { return }
        let formattedPrompt = """
        Analise o seguinte texto que contem uma receita (ingredientes e modo de preparo), provavelmente com algumas informacoes nao relevantes. Extraia os ingredientes e o modo de preparo de forma pratica e direta, sem inventar receita, e estruture-as no seguinte formato JSON: O objeto 'Meal' deve conter os campos 'idMeal' (null), 'strMeal' (nome da receita), 'categoria' (categoria, como sobremesa ou salgado ou "geral", nunca null), 'area' (origem geográfica da receita ou mundo, nunca vazia), 'strInstructions' (instrucao completa de como fazer a receita com cada grande passo dividido por ponto, nunca numerados por ordem, apenas o passo do modo de preparo em si), 'instructionSteps' (null), 'strMealThumb' (null), 'strTags' (null), 'strYoutube' (null), 'notes' (null), e 'ingredients' (um dicionário único, sem sub dicionarios, com os ingredientes e suas quantidades. Caso nao ache quantidade, coloque "A gosto", evitando ao maximo fazer isso. Coloque todos os igredientes, mesmo que de partes diferentes da receita, em um mesmo dicionario, nunca deve haver varios dicionarios dentro de ingredients, apenas 1 unificado). Ignorar qualquer conteúdo não relevante para a receita e focar apenas nos detalhes da receita. Não esqueca das virgulas, é importante que todas as chaves aparecam, mesmo que com null, e todas devem estar DENTRO do objeto Meal, inclusive o dicionario de ingredientes. Ignore hifens de pular linha. Texto:

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
                        if navigateToDetail {
                            PurchaseManager.shared.useCoins(1)
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
        sendRequest2(with: responseString)
    }
}

struct OCRView_Previews: PreviewProvider {
    static var previews: some View {
        OCRView()
    }
}
