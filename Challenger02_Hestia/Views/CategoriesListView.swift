import SwiftUI

struct CategoryListView: View {
    @StateObject var categoryViewModel = CategoryViewModel()

    var body: some View {
            List {
                if !categoryViewModel.meals.isEmpty {
                    Button(action: {
                        categoryViewModel.meals = []
                    }) {
                       RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .frame(width:20, height: 20)
                    }
                    Section(header: Text("Meals in \(categoryViewModel.selectedCategory?.strCategory ?? "")")) {
                        ForEach(categoryViewModel.meals) { meal in
                            HStack {
                                AsyncImage(url: meal.strMealThumb) { phase in
                                    if let image = phase.image {
                                        image.resizable()
                                    } else if phase.error != nil {
                                        Image(systemName: "photo") // Placeholder for error
                                    } else {
                                        ProgressView() // Loading indicator
                                    }
                                }
                                .frame(width: 50, height: 50)
                                .cornerRadius(8)

                                Text(meal.strMeal)
                            }
                        }
                    }
                } else {
                    Section(header: Text("Categories")) {
                        ForEach(categoryViewModel.categories) { category in
                            Button(action: {
                                print("Tentando selecionar:", category)
                                categoryViewModel.selectedCategory = category
                            }) {
                                HStack {
                                    AsyncImage(url: category.strCategoryThumb) { phase in
                                        if let image = phase.image {
                                            image.resizable()
                                        } else if phase.error != nil {
                                            Image(systemName: "photo") // Placeholder for error
                                        } else {
                                            ProgressView() // Loading indicator
                                        }
                                    }
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(8)

                                    VStack(alignment: .leading) {
                                        Text(category.strCategory).fontWeight(.medium)
                                        Text(category.strCategoryDescription)
                                            .font(.caption)
                                            .lineLimit(3)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                }
            }
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
    }
}
