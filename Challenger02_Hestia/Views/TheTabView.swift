import SwiftUI

struct TheTabView: View {

    var body: some View {
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
            
//            Text("Terceira Aba")
//                .tabItem {
//                    Image(systemName: "square.and.pencil")
//                    Text("Your recipes")
//                }
//                .toolbarBackground(.tabViewCor, for: .tabBar)
//                .toolbarBackground(.visible, for: .tabBar)
        }
        .tint(.tabViewItemCor)
    }
}

//#Preview {
//    TheTabView()
//}
