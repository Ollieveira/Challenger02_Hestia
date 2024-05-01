import SwiftUI
import SpriteKit

struct ContentView: View {
    @State private var routerState: Int = 1
    
    
    var body: some View {
        ZStack{
            switch(routerState){
            case(1):
                MealsListView()
            default: Text("Wow")
            }
        }
        
    }
}
