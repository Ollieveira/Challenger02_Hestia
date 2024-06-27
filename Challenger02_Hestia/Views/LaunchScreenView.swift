import SwiftUI

struct LaunchScreenView: View {
    @State var viewModel = MealViewModel.instance
    @State var showLaunchScreen = true
    @State var animaHestia = false
    @State var animaTitle = false
    
    var body: some View {
        Group {
            if showLaunchScreen {
                VStack {
                    if animaHestia {
                        Spacer()
                        Spacer()

                    }

                    
                    Spacer()
                    
                    Image("HestiaTitulo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: animaTitle ? 68 : 0)
                        .animation(.smooth(duration: 0.8), value: animaTitle)

                    
                    if !animaTitle {
                        Spacer()
                    }
                    
                    Spacer()
                    
                    Image("HestiaLaunchScreen")
                        .resizable()
                        .scaledToFit()
                        .offset(y: 50)
                        .frame(height: animaHestia ? 414 : 0)
                        .animation(.smooth(duration: 0.5), value: animaHestia)

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.degradeCor, Color.tabViewCor]), startPoint: .bottom, endPoint: .top)
                )
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        animaTitle.toggle()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            animaHestia.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                showLaunchScreen = false
                            }
                        }
                    }
                    if viewModel.meals.isEmpty {
                        Task {
                            viewModel.loadAllMeals()
                        }
                    }
                }
            } else {
                TheTabView()
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}
