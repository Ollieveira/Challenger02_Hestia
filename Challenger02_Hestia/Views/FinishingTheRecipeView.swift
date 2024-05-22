import SwiftUI

struct FinishingTheRecipeView: View {
    @Binding var isPresented: Bool
    var note: String
    var meal: Meal
    var viewModel: MealViewModel
    
    
    var body: some View {
        NavigationStack {
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
                        
                        
                        Text("Recipes")
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    VStack (alignment: .center) {
                        
                        NavigationLink(
                            destination: AddObservationView(isPresented: $isPresented, meal: meal, viewModel: viewModel)
                        ) {
                            CircleIconButton(systemName: "square.and.pencil", width: 70, height: 70, font: .title)
                        }
                        
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
                        
                        Text("Favorites")
                            .font(.subheadline)
                        
                    }
                    
                }
            }
            .padding(.horizontal, 36)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(RoundedRectangle(cornerRadius: 44)
                .fill(Color.backgroundCor)
            )
            .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden(true)
        }

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
