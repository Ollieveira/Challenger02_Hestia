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
                TextField("Search meals...", text: $viewModel.searchInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                ScrollView {
                    HStack(spacing: 20) {
                        VStack{
                            LazyVStack (spacing:20){
                                ForEach(Array(viewModel.filteredMeals.indices.filter { $0 % 2 == 0 }).filter { $0 < viewModel.filteredMeals.count }, id: \.self) { index in
                                    NavigationLink(
                                        destination: MealDetailView(meal: $viewModel.filteredMeals[index])
                                            .toolbar(.hidden, for: .tabBar)
                                    ) {
                                        MealRow(meal: viewModel.filteredMeals[index], indexInGrid: index, isLeftColumn: true)
                                    }
                                }
                            }
                            Spacer()
                        }
                        VStack{
                            LazyVStack (spacing: 20) {
                                ForEach(Array(viewModel.filteredMeals.indices.filter { $0 % 2 != 0 }).filter { $0 < viewModel.filteredMeals.count }, id: \.self) { index in
                                    NavigationLink(
                                        destination: MealDetailView(meal: $viewModel.filteredMeals[index])
                                            .toolbar(.hidden, for: .tabBar)
                                    ) {
                                        MealRow(meal: viewModel.filteredMeals[index], indexInGrid: index, isLeftColumn: false)
                                    }
                                }
                               
                            }
                            Spacer()
                        }
                     
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}
