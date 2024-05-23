import SwiftUI
import TelemetryClient

struct FinishingTheRecipeView: View {
    @Binding var isPresented: Bool
    var note: String
    var meal: Meal
    var viewModel: MealViewModel
    
    
    var body: some View {
            VStack (alignment: .center, spacing: 40) {
                VStack (alignment: .center){
                    Text("You've finished this recipe!")
                        .font(.title2)
                        .fontDesign(.rounded)
                        .fontWeight(.bold)
                    
                    Text("Congratulations! Now, what's next?")
                        .font(.headline)
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                }
                
                HStack {
                    
                    VStack (alignment: .center) {
                        NavigationLink(
                            destination: TheTabView()
                        ) {
                            CircleIconButton(systemName: "book.fill", width: 70, height: 70, font: .title)
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            // Envia o sinal de telemetria antes da navegação
                            TelemetryManager.send("navigationLinkPress", with: ["destination": "Recipes - FinishedRecipeView"])
                        })
                        
                        Text("Recipes")
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    VStack (alignment: .center) {
                        
                        NavigationLink(
                            destination: AddObservationView(isPresented: $isPresented, isSheet: false, meal: meal, viewModel: viewModel)
                        ) {
                            CircleIconButton(systemName: "square.and.pencil", width: 70, height: 70, font: .title)
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            // Envia o sinal de telemetria antes da navegação
                            TelemetryManager.send("navigationLinkPress", with: ["destination": "Create a note - FinishedRecipeView"])
                        })

                        
                        Text("Create a Note")
                            .font(.subheadline)
                        
                    }
                    Spacer()
                    
                    VStack (alignment: .center) {
                        
                        NavigationLink(
                            destination: YourRecipes()
                        ) {
                            CircleIconButton(systemName: "star.fill", width: 70, height: 70, font: .title)
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            // Envia o sinal de telemetria antes da navegação
                            TelemetryManager.send("navigationLinkPress", with: ["destination": "Favorites - FinishedRecipeView"])
                        })

                        
                        Text("Favorites")
                            .font(.subheadline)
                        
                    }
                    
                }
            }
            .padding(.horizontal, 36)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(RoundedRectangle(cornerRadius: 44)
                .fill(Color.bgFavCardCor)
            )
            .edgesIgnoringSafeArea(.all)
    }
    
    struct CircleIconButton: View {
        let systemName: String
        let width: CGFloat
        let height: CGFloat
        let font: Font
        
        var body: some View {
            ZStack {
                Circle()
                    .frame(width: width, height: height)
                    .foregroundStyle(Color.tabViewCor)
                Image(systemName: systemName)
                    .font(font)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.bgFavCardCor)
            }
        }
    }
    
}

//#Preview {
//    FinishingTheRecipeView(isPresented: .constant(true))
//}
