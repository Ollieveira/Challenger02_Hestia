import SwiftUI

struct MealSpeechView: View {
    
    @Binding var meal: Meal
    //    @State var recipeSteps: [String]
    //    @State var ingredients: [String: String]
    @State private var currentStepIndex = 0
    
    @State private var isReading = false
    @StateObject private var speechToText = SpeechToText(language: "en-US")
    
    //    @State private var shouldChangePage = false
    @State private var isListening = false
    
    
    
    var body: some View {
        VStack {
            Text(meal.strMeal)
            Image("IconTalksView")
            
            Text(meal.instructionSteps[currentStepIndex])
            
            HStack {
                CircleIconButton(systemName: "arrowshape.left.fill", width: 50, height: 50, font: .headline) {
                    if currentStepIndex < meal.instructionSteps.count - 1 {
                        currentStepIndex -= 1
                    }
                }
                
                Spacer()
                
                CircleIconButton(systemName: "arrowshape.right.fill", width: 50, height: 50, font: .headline) {
                    if currentStepIndex < meal.instructionSteps.count - 1 {
                        currentStepIndex += 1
                    }
                }

            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Faz a VStack ocupar toda a view
        .background(Color.backgroundCor.edgesIgnoringSafeArea(.all)) // Aplica a cor do background em toda a view
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
                }
            })
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



