import SwiftUI
import TelemetryClient

struct EverythingTogetherMenuView: View {
    @State var viewModel = MealViewModel.instance
    @State private var viewAppearTime: Date?
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                (
                   Text("Revele-me seus Desejos! O que procura?")
                )
                .fontDesign(.rounded)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 16)
                .padding(.horizontal, 15)
                
                ZStack (alignment: .trailing){
                        TextField("", text: $viewModel.searchInput)
                            .focused($isTextFieldFocused)
                            .font(.subheadline)
                            .padding(20)
                            .background(.white,
                                        in: RoundedRectangle(cornerRadius: 35, style: .continuous))
                            .shadow(radius: 1)
                    HStack{
                        if !isTextFieldFocused {
                            HStack{
                                Image(systemName: "magnifyingglass")
                                    .font(.title2)
                                    .foregroundColor(Color(.filterActiveCor))
                                VStack (alignment: .leading, spacing: 0){
                                    Text("Explorar...")
                                        .bold()
                                        .foregroundColor(Color(.tabViewCor))
                                        .opacity(0.4)
                                    Text("Procure o que deseja, mergulhe nos seus desejos!")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.leading, 12)
                        }
                        Spacer()
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
