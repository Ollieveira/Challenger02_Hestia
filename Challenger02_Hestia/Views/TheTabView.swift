import SwiftUI

struct TheTabView: View {
    @EnvironmentObject var purchaseManager: PurchaseManager
    
    var body: some View {
        NavigationStack {
            TabView {
                EverythingTogetherMenuView()
                    .tabItem {
                        Image(systemName: "book")
                        Text("Menu")
                    }
                    .toolbarBackground(.tabViewCor, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)

                YourRecipes()
                    .tabItem {
                        Image(systemName: "star.fill")
                        Text("Favorites")
                    }
                    .toolbarBackground(.tabViewCor, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                AddNewRecipeView()
                    .tabItem {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Recipe")
                    }
                    .toolbarBackground(.tabViewCor, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
            }
            .tint(.tabViewItemCor)
            .navigationTitle("Coins: \(purchaseManager.coins)")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        if purchaseManager.useCoins(1) {
                            print("Used 1 coin")
                        } else {
                            print("Not enough coins")
                        }
                    }) {
                        Text("Use Coin")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: PurchaseCoinsView()) {
                        Text("Buy Coins")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CoinListView()) {
                        Text("View Coins")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
