import SwiftUI

struct MealSearchView: View {
    @StateObject var viewModel = MealViewModel.instance

    var body: some View {
        NavigationStack {
            VStack {
                (
                    Text("What's on your")
                    +
                    Text(" menu ")
                        .foregroundStyle(.tabViewCor)
                    +
                    Text("today?")
                )
                .font(.title2)
                .fontDesign(.rounded)
                .bold()
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                
                ZStack (alignment: .trailing){
                    TextField("Search meals...", text: $viewModel.searchInput)
                        .font(.subheadline)
                        .padding(12)
                        .background(.thinMaterial,
                                    in: RoundedRectangle(cornerRadius: 12, style: .continuous))
//                        .padding(.top, 50)
                        .shadow(radius: 6)
                    
                    if !viewModel.searchInput.isEmpty {
                        Button(action: {
                            viewModel.searchInput = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.gray)
                                .padding(.trailing, 12)
//                                .padding(.top, 50)
                        }
                    }
                }
                .padding()


                

//                    .textFieldStyle(RoundedBorderTextFieldStyle())

                ScrollView {
                    HStack(spacing: 20) {
                        VStack{
                            LazyVStack (spacing:20){
                                ForEach(Array(viewModel.filteredIndices.enumerated().filter { $0.offset % 2 == 0 }), id: \.element) { offset, index in
                                    NavigationLink(
                                        destination: MealDetailView(meal: $viewModel.meals[index])
                                            .toolbar(.hidden, for: .tabBar)
                                    ) {
                                        MealRow(meal: viewModel.meals[index], indexInGrid: index, isLeftColumn: true)
                                    }
                                }
                            }
                            Spacer()
                        }
                        VStack{
                            LazyVStack (spacing: 20) {
                                ForEach(Array(viewModel.filteredIndices.enumerated().filter { $0.offset % 2 != 0 }), id: \.element) { offset, index in
                                    NavigationLink(
                                        destination: MealDetailView(meal: $viewModel.meals[index])
                                            .toolbar(.hidden, for: .tabBar)
                                    ) {
                                        MealRow(meal: viewModel.meals[index], indexInGrid: index, isLeftColumn: false)
                                    }
                                }
                               
                            }
                            Spacer()
                        }
                     
                    }
                    .padding(.horizontal)
                }
            }
            .onAppear{
                viewModel.filterMeals()
            }
            .background(Color.backgroundCor)
        }
    }
}
