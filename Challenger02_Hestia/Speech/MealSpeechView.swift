import SwiftUI
import TelemetryClient

struct MealSpeechView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var speechToText = SpeechToText(language: "en-US")
    @Binding var meal: Meal
    @State private var currentStepIndex = 0
    @State private var navigateToNextView = false
    @State private var isReading = false
    @State private var isListening = false
    @State var hasSeenOnboarding = false
    @StateObject var viewModel = MealViewModel.instance
    @State private var viewAppearTime: Date?


    
    var body: some View {
        
        let isLastStep = currentStepIndex == meal.instructionSteps.count - 1
        
        if hasSeenOnboarding {
            VStack (alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                
                Spacer()
                
                Text(meal.strMeal)
                    .font(.largeTitle).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                Spacer()
                
                Image("IconTalksView")
                
                Spacer()
                
                Text(meal.instructionSteps[currentStepIndex])
                    .font(.title2).fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    CircleIconButton(systemName: "arrowshape.left.fill", width: 50, height: 50, font: .headline) {
                        if currentStepIndex > 0 { // Verifica se currentStepIndex é maior que 0
                            currentStepIndex -= 1
                        }
                    }
                    .disabled(currentStepIndex == 0)
                    
                    
                    Spacer()
                    
                    CircleIconButton(systemName: isLastStep ? "checkmark" : "arrowshape.right.fill", width: 50, height: 50, font: .headline, action: {
                        if currentStepIndex < meal.instructionSteps.count - 1 {
                            currentStepIndex += 1
                        } else if isLastStep {
                            navigateToNextView = true
                            TelemetryManager.send("buttonPress", with: ["button": "Concluiu todos os passos da receita"])

                        }
                    }, isLastStep: isLastStep)
                    
                    Spacer()
                }
                
                Spacer()
                
                NavigationLink(value: navigateToNextView) {
                    EmptyView()
                }
            }
            .navigationDestination(isPresented: $navigateToNextView) {
                FinishingTheRecipeView(isPresented: $navigateToNextView, note: meal.notes ?? "", meal: meal, viewModel: viewModel)
            }
            .onAppear {
                // Registra o momento em que a view aparece
                viewAppearTime = Date()
                speechToText.speak(text: meal.instructionSteps[currentStepIndex], rate: 0.5)
                speechToText.startTranscribing()
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
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Faz a VStack ocupar toda a view
            .background(Color.backGroundCor.edgesIgnoringSafeArea(.all)) // Aplica a cor do background em toda a view
            .onChange(of: speechToText.currentWord) { oldWord, newWord in
                handleVoiceCommand(command: newWord)
            }
        } else {
            OnBoardingView(hasSeenOnboarding: $hasSeenOnboarding)
                .onDisappear {
                    hasSeenOnboarding = true
                }
        }
    }
    
    
    struct CircleIconButton: View {
        var systemName: String
        var width: CGFloat
        var height: CGFloat
        var font: Font
        var action: () -> Void
        var isLastStep: Bool?
        
        var body: some View {
            Button(action: action, label: {
                ZStack {
                    Circle()
                        .frame(width: width, height: height)
                        .foregroundStyle(isLastStep ?? false ? Color.checkButtonCor : Color.tabViewCor)
                    Image(systemName: systemName)
                        .font(font)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.buttonsContentCor)
                }
            })
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
            switch command {
            case "next":
                goToNextStep()
            case "back":
                goToPreviousStep()
            case "read":
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


