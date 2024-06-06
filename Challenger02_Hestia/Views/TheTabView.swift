import SwiftUI

struct TheTabView: View {
    @EnvironmentObject var purchaseManager: PurchaseManager
    @State var viewModel = MealViewModel.instance
    
    var body: some View {
            NavigationStack {
                TabView {
                    
                    AddNewRecipeView()
                        .tabItem {
                            Image(systemName: "plus.circle.fill")
                            Text("Adicionar Receita")
                        }
                        .toolbarBackground(.tabViewCor, for: .tabBar)
                        .toolbarBackground(.visible, for: .tabBar)
                    
                    EverythingTogetherMenuView()
                        .tabItem {
                            Image(systemName: "book")
                            Text("Receitas")
                        }
                        .toolbarBackground(.tabViewCor, for: .tabBar)
                        .toolbarBackground(.visible, for: .tabBar)
                    
                    YourRecipes()
                        .tabItem {
                            Image(systemName: "star.fill")
                            Text("Favoritos")
                        }
                        .toolbarBackground(.tabViewCor, for: .tabBar)
                        .toolbarBackground(.visible, for: .tabBar)
                    
                    
                }
                .onAppear {
                    // Load meals if empty
                    if viewModel.meals.isEmpty {
                        Task {
                            viewModel.loadAllMeals()
                        }
                    }
                    
                }
                .tint(.tabViewItemCor)
            }
            .navigationBarBackButtonHidden(true)
        }
}
