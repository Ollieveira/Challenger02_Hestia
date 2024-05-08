import SwiftUI

struct MealRow: View {
    let meal: Meal
    let indexInGrid: Int
    let isLeftColumn: Bool
    
    var body: some View {
        
        let isOdd: Bool = isLeftColumn ? indexInGrid % 4 == 0 : (indexInGrid - 1) % 4 == 0
        let dynamicHeight: CGFloat = calculateHeight(isOdd: isOdd, isLeftColumn: isLeftColumn)
        
        VStack {
            AsyncImage(url: meal.strMealThumb) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: UIScreen.main.bounds.width * 0.43, height: dynamicHeight)
            .cornerRadius(10)
            .overlay(
                VStack(alignment: .leading) {
                    Spacer()
                    HStack {
                        Text(meal.strMeal)
                            .font(.headline)
                            .foregroundStyle(.white)
                        Text(meal.strCategory)
                            .font(.subheadline)
                            .foregroundStyle(.white)
                        Text(meal.dietaryRestrictions.description)
                        Spacer()
                    }
                    .padding(5)
                }
                .background(Color.black.opacity(0.3))
                .cornerRadius(10)  // Apply the same corner radius as the image
                .clipped()  // Ensure that the overlay does not exceed the bounds of the rounded corners
            )
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
