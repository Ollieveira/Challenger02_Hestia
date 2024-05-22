import SwiftUI

struct MealSpeechView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var speechToText = SpeechToText(language: "en-US")
    @Binding var meal: Meal
    @State private var currentStepIndex = 0
    @State var showFinishedSheet = false
    @State private var isReading = false
    @State private var isListening = false
    @State var hasSeenOnboarding = false
    @StateObject var viewModel = MealViewModel.instance

    
    
    
    @StateObject private var speechToText = SpeechToText(language: "en-US")
    
    //    @State private var shouldChangePage = false
    
    
    
    var body: some View {
        if hasSeenOnboarding {
            VStack (alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                
                Spacer()
                
                Text(meal.strMeal)
                    .font(.largeTitle).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                Spacer()
                
                Image(speechToText.getIsSpeaking() ? "IconTalksViewTrue" : "IconTalksView")
                
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
                    
                    CircleIconButton(systemName: "arrowshape.right.fill", width: 50, height: 50, font: .headline) {
                        if currentStepIndex < meal.instructionSteps.count - 1 {
                            currentStepIndex += 1
                        }
                    }
                    .disabled(currentStepIndex == meal.instructionSteps.count - 1)
                    
                    
                    Spacer()
                }
                
                Spacer()
            }
            .onChange(of: currentStepIndex) { oldValue, newValue in
                // Verificar se atingiu o último item
                if newValue == meal.instructionSteps.count - 1 {
                    showFinishedSheet = true
                }
            }
            .fullScreenCover(isPresented: $showFinishedSheet) {
                // View específica a ser exibida
                FinishingTheRecipeView(isPresented: $showFinishedSheet, note: meal.notes ?? "", meal: meal, viewModel: viewModel)
            }
            
            .onAppear {
                speechToText.speak(text: meal.instructionSteps[currentStepIndex], rate: 0.5)
                speechToText.startTranscribing()
                
            }
            .onDisappear {
                dismiss()
                speechToText.stopTranscribing()
                speechToText.stopSpeaking()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Faz a VStack ocupar toda a view
            .background(Color.backgroundCor.edgesIgnoringSafeArea(.all)) // Aplica a cor do background em toda a view
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
        
        var body: some View {
            Button(action: action, label: {
                ZStack {
                    Circle()
                        .frame(width: width, height: height)
                        .foregroundStyle(Color.tabViewCor)
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





//    VStack {
//        Text("Última palavra: \(speechToText.currentWord)")
//        Text("Passo atual: \(meal.instructionSteps)")
//        Toggle("Reconhecimento de Voz", isOn: $isListening)
//            .padding()
//    }
//    .onChange(of: isListening) { oldValue, newValue in
//                if newValue {
//                    speechToText.startTranscribing()
//                } else {
//                    speechToText.stopTranscribing()
//                }
//            }
//    .onChange(of: speechToText.currentWord) { oldWord, newWord in
//        switch newWord {
//        case "next":
//            goToNextStep()
//        case "back":
//            goToPreviousStep()
//        case "read":
//            startReading()
//        case "pause":
//            pauseReading()
//        case "follow":
//            continueReading()
//        default:
//            break
//        }
//    }
////        .sheet(isPresented: $shouldChangePage) {
////            Text("Nova Pagina")
////        }
//
//}
//
//func goToNextStep() {
//    currentStepIndex = min(currentStepIndex + 1, recipeSteps.count - 1)
//    speechToText.speak(text: recipeSteps[currentStepIndex])
//}
//
//func goToPreviousStep() {
//    currentStepIndex = max(currentStepIndex - 1, 0)
//    speechToText.speak(text: recipeSteps[currentStepIndex])
//}
//
////    func changePage(to shouldChange: Bool) {
////        shouldChangePage = shouldChange
////    }
//
//func startReading() {
//    let fullText = recipeSteps.joined(separator: ". ")
//    speechToText.speak(text: fullText)
//}
//
//func pauseReading() {
//    speechToText.pauseSpeaking()
//}
//
//func continueReading() {
//    speechToText.continueSpeaking()
//}



