import SwiftUI

struct ToastView: View {
    var message: String
    var meal: Meal

    var body: some View {
        
        Spacer()
        
        HStack (spacing: 16) {
            if let url = meal.strMealThumb {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .aspectRatio(contentMode: .fit)
                .scaledToFill()
                .frame(maxWidth: 48, maxHeight: 48)
            } else {
                Image("defaultRecipeImage") // Replace with your local default image name
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaledToFill()
                    .frame(maxWidth: 48, maxHeight: 48)
            }
            
            Text(message)
                .font(.subheadline)
                .padding(.trailing, 16)
        }
        .background(Color.backgroundCor)
        .cornerRadius(8)
        .shadow(radius: 10)
        .transition(.opacity)
        .animation(.easeInOut, value: 1)

    }
}

//#Preview {
//    ToastView(message: "Adicionado aos Favoritos", meal: $meal)
//}
