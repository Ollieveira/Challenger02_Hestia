import SwiftUI
import SpriteKit

struct ContentView: View {
    @State private var routerState: Int = 1
    @State private var choosenMeal: Meal? = nil
    
    var body: some View {
        ZStack{
            switch(routerState){
            case(1):
                MealsListView(routerState: $routerState, chosenMeal: $choosenMeal)
            case(2):
                MealDetailView(routerState: $routerState, meal: choosenMeal!)
            case(3):
                SpeechView(recipeSteps: choosenMeal!.instructionSteps)
            default: Text("Wow")
            }
        }
        
    }
}


#Preview {
    ContentView()
}
