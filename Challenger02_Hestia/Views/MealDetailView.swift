import SwiftUI
import TelemetryClient
import CodableExtensions

struct MealDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var meal: Meal
    @State var viewModel = MealViewModel.instance
    @State private var isReading = false
    @State var isFavorite = false
    @State var showObservation = false
    @StateObject private var speechToText = SpeechToText(language: "pt-BR")
    
    var body: some View {
        VStack{
            ZStack (alignment: .top) {
                if let url = meal.strMealThumb {
                    AsyncImage(url: url) { image in
                    image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                        .aspectRatio(contentMode: .fit)
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: 265)
                } else {
                    Image("defaultRecipeImage") // Replace with your local default image name
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: 265)
                }
                
                // Adição de um efeito sombreado gradiente na parte superior do banner para deixar mais visivel os botões superiores
                
                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]), startPoint: .top, endPoint: .bottom)
                    .frame(maxWidth: .infinity, maxHeight: 265)
                    .clipShape(RoundedRectangle(cornerRadius: 40))
            }
            
            VStack {
                ScrollView {
                    HStack {
                        VStack (alignment: .leading){
                            Text(meal.strMeal)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text(meal.strArea ?? "")
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.tabViewCor)
                            
                            Spacer()
                            
                            Text("Ingredientes")
                                .font(.title2)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .padding(.top, 46)
                        }
                        .padding(.top, 34)
                        
                        Spacer()
                        
                        VStack (alignment: .center, spacing: 8){
                            
                            NavigationLink (
                                destination: MealSpeechView(meal: $meal)
                                ,
                                label: {
                                    ZStack {
                                        Circle()
                                            .frame(width: 50, height: 50)
                                            .foregroundStyle(Color.tabViewCor)
                                        Image(systemName: "play.fill")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.buttonsContentCor)
                                    }
                                }
                            )
                            .simultaneousGesture(TapGesture().onEnded {
                                                // Envia o sinal de telemetria antes da navegação
                                                TelemetryManager.send("navigationLinkPress", with: ["destination": "MealSpeechView"])
                                            })
                            
                            CircleIconButton(systemName: "headphones", width: 32, height: 32, font: .caption, hasNotes: false) {
                                
                                if speechToText.getIsSpeaking() && !speechToText.getIsPaused() {
                                    TelemetryManager.send("buttonPress", with: ["button": "Interrompeu a narração na MealDetailView"])
                                    // Se a leitura está em andamento, pare a leitura
                                    speechToText.stopSpeaking()
                                    isReading = false
                                } else {
                                    TelemetryManager.send("buttonPress", with: ["button": "Inicou a narração na MealDetailView"])

                                    // Se a leitura não está em andamento, comece a ler os ingredientes
                                    isReading = true
                                    
                                    speechToText.speak(text: "Vamos começar com os ingredientes e depois passaremos para os passos de preparação.", rate: 0.3)
                                    
                                    speechToText.speak(text: "Ingredientes", rate: 0.3)
                                    
                                    for (ingredient, measure) in meal.ingredients.sorted(by: >) {
                                        let formattedKey = ingredient.prefix(1).capitalized + ingredient.dropFirst()
                                        let ingredientText = "\(measure) of \(formattedKey)"
                                        speechToText.speak(text: ingredientText, rate: 0.3)
                                    }
                                    
                                    speechToText.speak(text: "Passos de Preparação", rate: 0.3)
                                    
                                    
                                    for step in meal.instructionSteps {
                                        // Configure a velocidade da leitura aqui (0.3 é 30% da velocidade normal)
                                        speechToText.speak(text: step, rate: 0.3)
                                    }
                                }
                            }
                            
                            CircleIconButton(systemName: "play.rectangle.fill", width: 32, height: 32, font: .caption2, hasNotes: false, action: {
                                TelemetryManager.send("buttonPress", with: ["button": "Ver video no YouTube"])

                                if let youtubeURL = meal.strYoutube {
                                    openURL(youtubeURL)
                                }
                            })
                            
                            CircleIconButton(systemName: "square.and.pencil", width: 32, height: 32, font: .subheadline, hasNotes: !(meal.notes?.isEmpty ?? true)) {
                                TelemetryManager.send("buttonPress", with: ["button": "Abrir tela Sheet de Notas"])

                                showObservation = true
                            }
                            .sheet(isPresented: $showObservation, content: {
                                AddObservationView(isPresented: $showObservation, isSheet: true, note: meal.notes ?? "", meal: meal, viewModel: viewModel)
                                    .presentationDetents([.medium, .large])
                                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                                    .presentationCornerRadius(44)
                                    .presentationDragIndicator(.visible)
                                    .onDisappear {
                                        showObservation = false
                                    }
                            })
                            
                        }
                        .padding(.top, 20)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.leading, 32)
                    .padding(.trailing, 24)
                    
                    
                    VStack (spacing: 16) {
                        ForEach(meal.ingredients.sorted(by: >), id: \.key) { key, value in
                            let formattedKey = key.prefix(1).capitalized + key.dropFirst()
                            BulletPointView(text: "\(formattedKey): \(value)")
                        }
                    }
                    .padding(.leading, 48)
                    
                    Text("Passos de Preparação")
                        .frame(maxWidth: .infinity, alignment: .leading).font(.title2).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.top, 30)
                        .padding(.bottom, 16)
                        .padding(.leading, 32)
                    
                    VStack (spacing: 16) {
                        ForEach(meal.instructionSteps, id: \.self) { step in
                            BulletPointView(text: "\(step)")
                        }
                    }
                    .padding(.leading, 48)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 44)
                    .fill(Color.backgroundCor)
            )
            .offset(y: -32)
            
            
        }
        .background(Color.backgroundCor)
        .edgesIgnoringSafeArea(.all)
        .onDisappear {
            speechToText.stopSpeaking()
        }
        
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            dismiss()
            speechToText.stopSpeaking()
            
        }) {
            Image(systemName: "arrowshape.left.fill")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(Color.buttonsContentCor)
        })
        .navigationBarItems(trailing: Button(action: {
            // Colocar funcionalidade de adicionar receita aos favoritos
            if isFavorite {
                viewModel.removeFromFavorites(meal: meal)
                TelemetryManager.send("buttonPress", with: ["button": "Removeu dos Favoritos"])

            } else {
                viewModel.addToFavorites(meal: meal)
                TelemetryManager.send("buttonPress", with: ["button": "Adicionou aos Favoritos"])

            }
            isFavorite.toggle()
        }) {
            Image(systemName: isFavorite ? "star.fill" : "star")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(isFavorite ? Color.tabViewCor : Color.buttonsContentCor)
        })
        .onAppear {
            isFavorite = viewModel.favoriteMeals.contains(where: { $0.id == meal.id })
        }
        
        
    }
    
    struct BulletPointView: View {
        let text: String
        
        var body: some View {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text("•")
                    .offset(y: 4)
                    .font(.largeTitle)
                    .foregroundStyle(Color.tabViewCor)
                Text(text)
                Spacer()
            }
        }
    }
    
    struct CircleIconButton: View {
        let systemName: String
        let width: CGFloat
        let height: CGFloat
        let font: Font
        let hasNotes: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action, label: {
                ZStack {
                    Circle()
                        .frame(width: width, height: height)
                        .foregroundStyle(Color.tabViewCor)
                    if hasNotes {
                        Image(systemName: "circle.fill")
                            .font(.caption)
                            .foregroundStyle(Color.notificationCor)
                            .offset(x: -12, y: -12)
                    }
                    Image(systemName: systemName)
                        .font(font)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.buttonsContentCor)
                    
                }
                
            })
        }
    }
    
    func openURL(_ url: URL) {
        UIApplication.shared.open(url)
    }
}





//Text("Category: \(meal.strCategory)")
//
//
//if let tags = meal.strTags {
//    Text("Tags: \(tags)")
//}






