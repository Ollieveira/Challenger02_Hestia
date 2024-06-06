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
                    Text("Você terminou esta receita!")
                        .font(.title2)
                        .fontDesign(.rounded)
                        .fontWeight(.bold)
                    
                    Text("Parabéns! Agora, o que vem a seguir?")
                        .font(.headline)
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                }
                
                HStack {
                    
                    VStack (alignment: .center) {
                        NavigationLink(
                            destination: TheTabView()
                        ) {
                            CircleIconButton(systemName: "plus.circle.fill", width: 70, height: 70, font: .title)
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            // Envia o sinal de telemetria antes da navegação
                            TelemetryManager.send("navigationLinkPress", with: ["destination": "Recipes - FinishedRecipeView"])
                        })
                        
                        Text("Nova Receita")
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

                        
                        Text("Criar nota")
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

                        
                        Text("Favoritos")
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
