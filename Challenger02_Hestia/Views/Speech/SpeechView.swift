import SwiftUI

struct SpeechView: View {
    @State var recipeSteps: [String]
    
    @StateObject private var speechToText = SpeechToText(language: "en-US")
//    @State private var shouldChangePage = false
    @State private var isListening = false
// Dados da API com os passos da receita
    
    @State private var currentStepIndex = 0
    
    var body: some View {
        VStack {
            Text("Última palavra: \(speechToText.currentWord)")
            Text("Passo atual: \(recipeSteps[currentStepIndex])")
            Toggle("Reconhecimento de Voz", isOn: $isListening)
                .padding()
        }
        .onChange(of: isListening) { oldValue, newValue in
                    if newValue {
                        speechToText.startTranscribing()
                    } else {
                        speechToText.stopTranscribing()
                    }
                }
        .onChange(of: speechToText.currentWord) { oldWord, newWord in
            switch newWord {
            case "next":
                goToNextStep()
            case "back":
                goToPreviousStep()
            case "read":
                startReading()
            case "pause":
                pauseReading()
            case "follow":
                continueReading()
            default:
                break
            }
        }
//        .sheet(isPresented: $shouldChangePage) {
//            Text("Nova Pagina")
//        }
        
    }
    
    func goToNextStep() {
        currentStepIndex = min(currentStepIndex + 1, recipeSteps.count - 1)
        speechToText.speak(text: recipeSteps[currentStepIndex])
    }

    func goToPreviousStep() {
        currentStepIndex = max(currentStepIndex - 1, 0)
        speechToText.speak(text: recipeSteps[currentStepIndex])
    }

//    func changePage(to shouldChange: Bool) {
//        shouldChangePage = shouldChange
//    }

    func startReading() {
        let fullText = recipeSteps.joined(separator: ". ")
        speechToText.speak(text: fullText)
    }

    func pauseReading() {
        speechToText.pauseSpeaking()
    }

    func continueReading() {
        speechToText.continueSpeaking()
    }

}
