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
    @State private var toastMessage: String = ""
    @State private var showToast: Bool = false
    @State private var showOverlay = false
    @State private var buttonPosition: CGRect = .zero
    @StateObject private var speechToText = SpeechToText(language: "pt-BR")
    
    var body: some View {
        ZStack {
            VStack {
                VStack (alignment: .leading, spacing: 8) {
                    
                    Text(meal.strMeal)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    
                    Text(meal.strArea?.capitalizingFirstLetter() ?? "".capitalizingFirstLetter())
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.tabViewCor)
                        .multilineTextAlignment(.leading)
                    
                    
                    if let url = meal.strMealThumb {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .aspectRatio(contentMode: .fit)
                        .scaledToFill()
                        .frame(maxWidth: 350, maxHeight: 178)
                        .cornerRadius(10)
                        
                    } else {
                        Image("defaultRecipeImage")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaledToFill()
                            .frame(maxWidth: 350, maxHeight: 178)
                            .cornerRadius(10)
                    }
                }
                
                    HStack (spacing: 12) {
                        
                        Spacer()
                        
                        if let notes = meal.notes, !notes.isEmpty {
                            CircleIconButton(systemName: "square.and.pencil", width: 32, height: 32, font: .subheadline) {
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
                        
                        NavigationLink (
                            destination: MealSpeechView(meal: $meal)
                            ,
                            label: {
                                HStack (spacing: 8) {
                                    Image(systemName: "play.fill")
                                        .font(.body)
                                        .foregroundColor(.backgroundCor)
                                        .fontWeight(.semibold)
                                    
                                    Text("Começar")
                                        .foregroundColor(.backgroundCor)
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                }
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.onBoradingButtonCor)
                                )
                            }

                        )
                        .simultaneousGesture(TapGesture().onEnded {
                            // Envia o sinal de telemetria antes da navegação
                            TelemetryManager.send("navigationLinkPress", with: ["destination": "MealSpeechView"])
                        })
                        
                        Button(action: {
                            withAnimation {
                                showOverlay.toggle()
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .frame(width: 32, height: 32)
                                    .foregroundStyle(Color.backgroundCor)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.tabViewCor, lineWidth: 2)
                                    )
                                
                                Image(systemName: "arrowtriangle.down.fill")
                                    .font(.body)
                                    .foregroundColor(Color.tabViewCor)
                            }

                        }
                        .background(GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    DispatchQueue.main.async {
                                        self.buttonPosition = geometry.frame(in: .global)
                                    }
                                }
                        })
                    }
                    .padding(.horizontal, 24).padding(.top, 8)
                
                VStack {
                    ScrollView {
                        Text("Ingredientes")
                            .frame(maxWidth: .infinity, alignment: .leading).font(.title2).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding(.top, 16)
                            .padding(.bottom, 16)
                            .padding(.leading, 32)
                        
                        
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
            }
            .background(Color.backgroundCor)
            .onDisappear {
                speechToText.stopSpeaking()
            }
            
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                dismiss()
                speechToText.stopSpeaking()
                
            }) {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.regular)
                    .foregroundStyle(Color.tabViewCor)
            })
            .navigationBarItems(trailing: Button(action: {
                // Colocar funcionalidade de adicionar receita aos favoritos
                if isFavorite {
                    viewModel.removeFromFavorites(meal: meal)
                    TelemetryManager.send("buttonPress", with: ["button": "Removeu dos Favoritos"])
                    toastMessage = "Removido dos Favoritos"
                    
                } else {
                    viewModel.addToFavorites(meal: meal)
                    TelemetryManager.send("buttonPress", with: ["button": "Adicionou aos Favoritos"])
                    toastMessage = "Salvo nos Favoritos"
                    
                }
                isFavorite.toggle()
                showToastWithMessage(toastMessage)
                
            }) {
                Image(systemName: isFavorite ? "bookmark.fill" : "bookmark")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(isFavorite ? Color.tabViewCor : Color.tabViewCor)
            })
            .overlay(
                VStack {
                    if showToast {
                        ToastView(message: toastMessage, meal: meal)
                            .padding(.top, 50)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    withAnimation {
                                        showToast = false
                                    }
                                }
                            }
                    }
                    Spacer()
                }
            )
            
            .onAppear {
                isFavorite = viewModel.favoriteMeals.contains(where: { $0.id == meal.id })
            }
            
            if showOverlay {
                Color.tabViewCor.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            showOverlay = false
                        }
                    }
                VStack {
                    HStack  {
                        Text("Ler Receita")
                            .font(.footnote).fontWeight(.semibold)
                            .foregroundStyle(Color.tabViewCor)
                        
                        Spacer()
                        
                        CircleIconButton(systemName: "speaker.wave.2", width: 32, height: 32, font: .caption) {
                            if speechToText.getIsSpeaking() && !speechToText.getIsPaused() {
                                TelemetryManager.send("buttonPress", with: ["button": "Interrompeu a narração na MealDetailView"])
                                speechToText.stopSpeaking()
                                isReading = false
                                withAnimation {
                                    showOverlay.toggle()
                                }
                            } else {
                                TelemetryManager.send("buttonPress", with: ["button": "Inicou a narração na MealDetailView"])
                                isReading = true
                                withAnimation {
                                    showOverlay.toggle()
                                }

                                speechToText.speak2(text: "Vamos começar com os ingredientes e depois passaremos para os passos de preparação.", rate: 0.3)
                                speechToText.speak2(text: "Ingredientes", rate: 0.3)
                                
                                for (ingredient, measure) in meal.ingredients.sorted(by: >) {
                                    let formattedKey = ingredient.prefix(1).capitalized + ingredient.dropFirst()
                                    let ingredientText = "\(measure) de \(formattedKey)"
                                    speechToText.speak2(text: ingredientText, rate: 0.3)
                                }
                                
                                speechToText.speak2(text: "Passos de Preparação", rate: 0.3)
                                
                                for step in meal.instructionSteps {
                                    speechToText.speak2(text: step, rate: 0.3)
                                }
                            }
                        }
                    }
                    
                    if meal.strYoutube != nil {
                        HStack {
                            Text("Video da Receita")
                                .font(.footnote).fontWeight(.semibold)
                                .foregroundStyle(Color.tabViewCor)
                            
                            Spacer()
                            
                            CircleIconButton(systemName: "play.rectangle.fill", width: 32, height: 32, font: .caption2, action: {
                                TelemetryManager.send("buttonPress", with: ["button": "Ver video no YouTube"])
                                
                                if let youtubeURL = meal.strYoutube {
                                    openURL(youtubeURL)
                                }
                            })
                        }
                    }
                    
                    
                    HStack {
                        Text("Criar Anotação")
                            .font(.footnote).fontWeight(.semibold)
                            .foregroundStyle(Color.tabViewCor)
                        
                        Spacer()
                        
                        CircleIconButton(systemName: "square.and.pencil", width: 32, height: 32, font: .subheadline) {
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
                }
                .padding()
                .frame(maxWidth: 200)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
                .position(x: buttonPosition.midX - 80, y: buttonPosition.maxY - 15) // Ajuste da distância do menu em relação ao botão
            }
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
//        let hasNotes: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action, label: {
                ZStack {
                    Circle()
                        .frame(width: width, height: height)
                        .foregroundStyle(Color.tabViewCor)
//                    if hasNotes {
//                        Image(systemName: "circle.fill")
//                            .font(.caption)
//                            .foregroundStyle(Color.notificationCor)
//                            .offset(x: -12, y: -12)
//                    }
                    Image(systemName: systemName)
                        .font(font)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.buttonsContentCor)
                    
                }
                
            })
        }
    }
    
    private func showToastWithMessage(_ message: String) {
        toastMessage = message
        withAnimation {
            showToast = true
        }
    }
    
    
    func openURL(_ url: URL) {
        UIApplication.shared.open(url)
    }
}











