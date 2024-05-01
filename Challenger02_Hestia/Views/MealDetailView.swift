import SwiftUI

struct MealDetailView: View {
    let meal: Meal

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: meal.strMealThumb) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .aspectRatio(contentMode: .fit)
                
                Text(meal.strMeal)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Category: \(meal.strCategory)")
                Text("Cuisine: \(meal.strArea)")
                if let tags = meal.strTags {
                    Text("Tags: \(tags)")
                }
                
                VStack(alignment: .leading) {
                    Text("Instructions:")
                        .fontWeight(.semibold)
                    ForEach(meal.instructionSteps, id: \.self) { step in
                        Text(step)
                            .padding(.bottom, 2)
                        Divider()
                    }
                }
                
                Text("Ingredients and Measures:")
                    .fontWeight(.semibold)
                ForEach(meal.ingredients.sorted(by: >), id: \.key) { key, value in
                    Text("\(key): \(value)")
                }

                if let youtubeURL = meal.strYoutube {
                    Link("Watch on YouTube", destination: youtubeURL)
                }
            }
            .padding()
        }
        .safeAreaPadding(.all)
        .navigationTitle(meal.strMeal)
        .navigationBarTitleDisplayMode(.inline)
    }
}
