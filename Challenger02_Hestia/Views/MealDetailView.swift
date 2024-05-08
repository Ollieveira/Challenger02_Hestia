import SwiftUI

struct MealDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var meal: Meal
    
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
                            
                            CircleIconButton(systemName: "play.fill", width: 50, height: 50, font: .headline) {
                                
                            }
                            
                            CircleIconButton(systemName: "headphones", width: 32, height: 32, font: .caption) {
                                
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
                    .padding(.trailing, 16)

                    
                    VStack {
                        ForEach(meal.ingredients.sorted(by: >), id: \.key) { key, value in
                            BulletPointView(text: "\(key): \(value)")
                        }
                    }
                    .padding(.leading, 48)
                    
//                    VStack(alignment: .leading, spacing: 20) {
//                        
//                        
//                        Text("Category: \(meal.strCategory)")
//                        Text("Cuisine: \(meal.strArea)")
//                        if let tags = meal.strTags {
//                            Text("Tags: \(tags)")
//                        }
//                        
//                        VStack(alignment: .leading) {
//                            Text("Instructions:")
//                                .fontWeight(.semibold)
//                            ForEach(meal.instructionSteps, id: \.self) { step in
//                                Text(step)
//                                    .padding(.bottom, 2)
//                                Divider()
//                            }
//                        }
//                    }
//                    .padding()
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
            HStack(alignment: .center) {
                Text("•")
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





