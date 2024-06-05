import SwiftUI
import TelemetryClient

struct EverythingTogetherMenuView: View {
    @State var viewModel = MealViewModel.instance
    @State private var viewAppearTime: Date?

    
    var body: some View {
        NavigationStack {
            VStack {
                (
                    Text("It's time to cook your")
                    +
                    Text(" hungry ")
                        .foregroundStyle(.tabViewCor)
                    +
                    Text("out!")
                )
                .font(.title2)
                .fontDesign(.rounded)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                
                ZStack (alignment: .trailing){
                        TextField("Search meals...", text: $viewModel.searchInput)
                            .font(.subheadline)
                            .padding(12)
                            .background(.thinMaterial,
                                        in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .shadow(radius: 6)
                    
                    if !viewModel.searchInput.isEmpty {
                        Button(action: {
                            viewModel.searchInput = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.gray)
                                .padding(.trailing, 12)
                        }
                    }
                }
                .padding()
                
                
                ButtonStyleMenuView()
                
                MealsListView()
            }
            .onAppear {
                // Registra o momento em que a view aparece
                viewAppearTime = Date()
            }
            .onDisappear {
                // Calcula o tempo que a view ficou visível
                if let viewAppearTime = viewAppearTime {
                    let viewDisappearTime = Date()
                    let duration = viewDisappearTime.timeIntervalSince(viewAppearTime)
                    // Envia o sinal de telemetria com a duração
                    TelemetryManager.send("viewDuration", floatValue: duration, with: ["page": "MainPage"])
                }
            }
            .background(Color.backgroundCor)
        }
    }
}
