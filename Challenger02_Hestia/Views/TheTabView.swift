import SwiftUI

struct TheTabView: View {
    
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
                
                MealSearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
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
            }
            .tint(.tabViewItemCor)
        }
        .navigationBarBackButtonHidden(true)
    }
}

//#Preview {
//    TheTabView()
//}
