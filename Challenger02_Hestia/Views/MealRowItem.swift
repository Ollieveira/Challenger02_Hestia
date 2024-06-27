import SwiftUI
import Kingfisher

struct MealRow: View {
    let meal: Meal
    let indexInGrid: Int
    let isLeftColumn: Bool
    
    var body: some View {
        
        let isOdd: Bool = isLeftColumn ? indexInGrid % 4 == 0 : (indexInGrid - 1) % 4 == 0
        let dynamicHeight: CGFloat = calculateHeight(isOdd: isOdd, isLeftColumn: isLeftColumn)
        
        VStack {
            if let url = meal.strMealThumb {
                KFImage(url)
                    .cacheMemoryOnly()
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width * 0.43, height: dynamicHeight)
                    .cornerRadius(5)
                    .overlay(
                        //LinearGradient(gradient: Gradient(colors: [Color.tabViewCor.opacity(0.5), Color.clear]), startPoint: .bottom, endPoint: .top)
                        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.75), Color.clear]), startPoint: .bottom, endPoint: .top)
                        .frame(width: UIScreen.main.bounds.width * 0.43, height: dynamicHeight)
                        .aspectRatio(1.0, contentMode: .fit)
                        .cornerRadius(5)
                        .opacity(0.5)
                        .overlay(
                            VStack(alignment: .leading) {
                                Spacer()
                                HStack {
                                    Text(meal.strMeal)
                                        .font(.subheadline)
                                        .foregroundStyle(.white)
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.leading)
                                    // Alterado para branco para melhorar a legibilidade
                                    Spacer()
                                }
                                .padding(5)
                            }
                        )
                    )

            } else {
                Image("defaultRecipeImage") // Replace with your local default image name
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width * 0.43, height: dynamicHeight)
                    .cornerRadius(5)
                    .overlay(
                        //LinearGradient(gradient: Gradient(colors: [Color.tabViewCor.opacity(0.5), Color.clear]), startPoint: .bottom, endPoint: .top)
                        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.75), Color.clear]), startPoint: .bottom, endPoint: .top)
                        .frame(width: UIScreen.main.bounds.width * 0.43, height: dynamicHeight)
                        .aspectRatio(1.0, contentMode: .fit)
                        .cornerRadius(5)
                        .opacity(0.5)
                        .overlay(
                            VStack(alignment: .leading) {
                                Spacer()
                                HStack {
                                    Text(meal.strMeal)
                                        .font(.subheadline)
                                        .foregroundStyle(.white)
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.leading)
                                    // Alterado para branco para melhorar a legibilidade
                                    Spacer()
                                }
                                .padding(5)
                            }
                        )
                    )

            }

        }
        .frame(width: UIScreen.main.bounds.width * 0.43, height: dynamicHeight)
    }
    
    private func calculateHeight(isOdd: Bool, isLeftColumn: Bool) -> CGFloat {
        if (isLeftColumn && isOdd) || (!isLeftColumn && !isOdd){
            return UIScreen.main.bounds.height * 0.25 // Larger size for odd items in left column or even items in right column
        } else {
            return UIScreen.main.bounds.height * 0.20
        }
    }
}
