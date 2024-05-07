import SwiftUI

struct TheTabView: View {
    @Binding var router: Router
    @Binding var chosenMeal: Meal?


    var body: some View {
        TabView {
            EverythingTogetherMenuView(router: $router, chosenMeal: $chosenMeal)
                .tabItem {
                    Image(systemName: "book")
                    Text("Menu")
                }
                .toolbarBackground(.tabViewCor, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
            
            CategoryListView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .toolbarBackground(.tabViewCor, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
            
            Text("Terceira Aba")
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("Your recipes")
                }
                .toolbarBackground(.tabViewCor, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
        }
        .tint(.tabViewItemCor)
    }
}

//#Preview {
//    TheTabView()
//}
