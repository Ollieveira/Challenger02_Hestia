import SwiftUI

struct MealRow: View {
    let meal: Meal

    var body: some View {
        HStack {
            AsyncImage(url: meal.strMealThumb) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 80, height: 80)
            .cornerRadius(10)

            VStack(alignment: .leading) {
                Text(meal.strMeal)
                    .font(.headline)
                Text(meal.strCategory)
                    .font(.subheadline)
            }
        }
    }
}
     
