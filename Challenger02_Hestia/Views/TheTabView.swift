import SwiftUI

struct TheTabView: View {
    @EnvironmentObject var purchaseManager: PurchaseManager
    @State var viewModel = MealViewModel.instance
    
    var body: some View {
        NavigationStack {
            TabView {
                
                AddNewRecipeView()
                    .tabItem {
                        Image(systemName: "fireplace")
                        Text("Hestia")
                    }
                    .toolbarBackground(.backgroundCor, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                
                EverythingTogetherMenuView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Pesquisar")
                    }
                    .toolbarBackground(.backgroundCor, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                
                YourRecipes()
                    .tabItem {
                        Image(systemName: "heart")
                        Text("Sua Área")
                    }
                    .toolbarBackground(.backgroundCor, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                
                
            }
            
        }
        .tint(.tabViewItemCor)
        .navigationBarBackButtonHidden(true)
    }
}
