import SwiftUI

struct MealDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var meal: Meal
    @State private var isReading = false
    @StateObject private var speechToText = SpeechToText(language: "en-US")

    
    var body: some View {
        VStack{
            ZStack (alignment: .top) {
                AsyncImage(url: meal.strMealThumb) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .aspectRatio(contentMode: .fit)
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: 265)
                .clipShape(RoundedRectangle(cornerRadius: 40))
                
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
                            
                            Text(meal.strArea)
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.textTitleCor)
                            
                            Spacer()
                            
                            Text("Ingredients")
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
                                    }
                                }
                            )
                            
                            CircleIconButton(systemName: "headphones", width: 32, height: 32, font: .caption) {
                                if speechToText.isSpeaking && !speechToText.isPaused {
                                    // Se a leitura está em andamento, pare a leitura
                                    speechToText.stopSpeaking()
                                    isReading = false
                                    print(isReading)
                                } else {
                                    // Se a leitura não está em andamento, comece a ler os ingredientes
                                    isReading = true
                                    
                                    print(isReading)

                                    
                                    speechToText.speak(text: "Let's start with the ingredients and then we'll move on to the preparation steps.", rate: 0.3)

                                    speechToText.speak(text: "Ingredients", rate: 0.3)
                                    
                                    for (ingredient, measure) in meal.ingredients.sorted(by: >) {
                                        let formattedKey = ingredient.prefix(1).capitalized + ingredient.dropFirst()
                                        let ingredientText = "\(measure) of \(formattedKey)"
                                        speechToText.speak(text: ingredientText, rate: 0.3)
                                    }
                                    
                                    speechToText.speak(text: "Directions", rate: 0.3)

                                    
                                    for step in meal.instructionSteps {
                                        // Configure a velocidade da leitura aqui (0.3 é 30% da velocidade normal)
                                        speechToText.speak(text: step, rate: 0.3)
                                    }
                                }
                            }

                            CircleIconButton(systemName: "play.rectangle.fill", width: 32, height: 32, font: .caption2, action: {
                                if let youtubeURL = meal.strYoutube {
                                    openURL(youtubeURL)
                                }
                            })
                            
                            CircleIconButton(systemName: "square.and.pencil", width: 32, height: 32, font: .subheadline) {
                                
                            }
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
                    
                    Text("Directions")
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
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            dismiss()
            speechToText.stopSpeaking()

        }) {
            Image(systemName: "arrowshape.left.fill") 
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(.bold)
        })
        .navigationBarItems(trailing: Button(action: {
            // Colocar funcionalidade de adicionar receita aos favoritos
        }) {
            Image(systemName: "star.fill")
                .font(.title2)
                .fontWeight(.bold)
        })


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






