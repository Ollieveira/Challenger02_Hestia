
import SwiftUI
import TelemetryClient

struct MealSpeechView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var speechToText = SpeechToText(language: "pt-BR")
    @Binding var meal: Meal
    @State private var currentStepIndex = 0
    @State private var navigateToNextView = false
    @State private var isReading = false
    @State private var isListening = false
    @State var hasSeenOnboarding = false
    @State var viewModel = MealViewModel.instance
    @State private var viewAppearTime: Date?
    
    var body: some View {
        
        let isLastStep = currentStepIndex == meal.instructionSteps.count - 1
        
        if hasSeenOnboarding {
            VStack (alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                VStack (alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                    
                    Image(speechToText.isSpeaking ? "HestiaSpeechNoTalk" : "HestiaSpeechTalk")
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 8).padding(.bottom, 22)
                    
                    Divider()
                    
                    Text(meal.strMeal)
                        .font(.title2).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(Color.tabViewCor)
                        .padding(.top, 8)
                    
                    
                    Text(meal.instructionSteps[currentStepIndex])
                        .frame(height: 80)
                        .font(.body).fontWeight(.regular)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.gray)
                    
                    
                    HStack {
                        
                        CircleIconButton(systemName: "arrowshape.left.fill",  width: isLastStep ? 50 : 30, height: isLastStep ? 50 : 30, font: isLastStep ? .headline : .footnote) {
                            if currentStepIndex > 0 { // Verifica se currentStepIndex é maior que 0
                                currentStepIndex -= 1
                            }
                        }
                        .disabled(currentStepIndex == 0)
                        
                        Spacer()
                        
                        CircleIconButton(systemName: isLastStep ? "checkmark" : "arrowshape.right.fill", width: isLastStep ? 50 : 30, height: isLastStep ? 50 : 30, font: isLastStep ? .headline : .footnote, action: {
                            if currentStepIndex < meal.instructionSteps.count - 1 {
                                currentStepIndex += 1
                            } else if isLastStep {
                                navigateToNextView = true
                                TelemetryManager.send("buttonPress", with: ["button": "Concluiu todos os passos da receita"])
                            }
                        }, isLastStep: isLastStep)
                        
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .padding(.horizontal, 32).padding(.bottom, 20)
                    
                    Spacer()
                    
                    NavigationLink(value: navigateToNextView) {
                        EmptyView()
                    }
                }
                .padding(.horizontal, 32).padding(.top, 72).padding(.bottom, 32)
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
                
                .navigationDestination(isPresented: $navigateToNextView) {
                    FinishingTheRecipeView(isPresented: $navigateToNextView, note: meal.notes ?? "", meal: meal, viewModel: viewModel)
                }
                .onAppear {
                    // Registra o momento em que a view aparece
                    viewAppearTime = Date()
                    speechToText.speak(text: meal.instructionSteps[currentStepIndex], rate: 0.5)
                    UIApplication.shared.isIdleTimerDisabled = true
                }
                .onDisappear {
                    // Calcula o tempo que a view ficou visível
                    if let viewAppearTime = viewAppearTime {
                        let viewDisappearTime = Date()
                        let duration = viewDisappearTime.timeIntervalSince(viewAppearTime)
                        // Envia o sinal de telemetria com a duração
                        TelemetryManager.send("viewDuration", floatValue: duration, with: ["page": "MealSpeechView"])
                    }
                    dismiss()
                    speechToText.stopTranscribing()
                    speechToText.stopSpeaking()
                    UIApplication.shared.isIdleTimerDisabled = false
                }
                .onChange(of: speechToText.currentWord) { oldWord, newWord in
                    print("palavra atual -> \(newWord)")
                    handleVoiceCommand(command: newWord)
                }
            }
            .background(Color.backgroundCor)
            .edgesIgnoringSafeArea(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Faz a VStack ocupar toda a view
        } else {
            OnBoardingView(hasSeenOnboarding: $hasSeenOnboarding)
                .onDisappear {
                    hasSeenOnboarding = true
                }
        }
    }
    
    func goToNextStep() {
        currentStepIndex = min(currentStepIndex + 1, meal.instructionSteps.count - 1)
        speechToText.speak(text: meal.instructionSteps[currentStepIndex], rate: 0.5)
    }
    
    func goToPreviousStep() {
        currentStepIndex = max(currentStepIndex - 1, 0)
        speechToText.speak(text: meal.instructionSteps[currentStepIndex], rate: 0.5)
    }
    
    func pauseReading() {
        speechToText.pauseSpeaking()
    }
    
    func continueReading() {
        speechToText.continueSpeaking()
    }
    
    private func handleVoiceCommand(command: String) {
        let normalizedCommand = command.lowercased().folding(options: .diacriticInsensitive, locale: .current).trimmingCharacters(in: .whitespacesAndNewlines)
        switch normalizedCommand {
        case "passe":
            goToNextStep()
        case "volte":
            goToPreviousStep()
        case "leia":
            speechToText.speak(text: meal.instructionSteps[currentStepIndex], rate: 0.5)
        case "pause":
            pauseReading()
        case "continue":
            continueReading()
        default:
            break
        }
    }
}

struct CircleIconButton: View {
    var systemName: String
    var width: CGFloat
    var height: CGFloat
    var font: Font
    var action: () -> Void
    var isLastStep: Bool? = false
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .frame(width: width, height: height)
                    .foregroundStyle(isLastStep ?? false ? Color.checkButtonCor : Color.backgroundCor)
                    .overlay(
                        Circle()
                            .stroke(isLastStep ?? false ? Color.checkButtonCor : Color.tabViewCor, lineWidth: 2) // Ajuste a largura da borda aqui
                    )
                Image(systemName: systemName)
                    .font(font)
                    .fontWeight(.semibold)
                    .foregroundStyle(isLastStep ?? false ? Color.buttonsContentCor : Color.tabViewCor)
            }
        }
    }
}



