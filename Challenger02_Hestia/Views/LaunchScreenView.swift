import SwiftUI

struct LaunchScreenView: View {
    @State var viewModel = MealViewModel.instance
    @State var contador = 1
    @State var goToNextView = false
    @State var animaHestia = false
    @State var animaTitle = false
    
    
    
    var body: some View {
        NavigationStack {
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
                    .animation(.smooth(duration: 0.5), value: animaTitle)

                
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
            .navigationDestination(isPresented: $goToNextView, destination: {
                TheTabView()
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.degradeCor, Color.tabViewCor]), startPoint: .bottom, endPoint: .top)
            )
            .edgesIgnoringSafeArea(.all)
            
            .animation(.default, value: goToNextView)
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    animaTitle.toggle()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1)
                    {
                        animaHestia.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
                        {
                            goToNextView.toggle()
                        }
                    }
                }
                if viewModel.meals.isEmpty {
                    Task {
                        viewModel.loadAllMeals()
                    }
                }
            }
            .animation(.smooth(duration: 0.5), value: animaHestia)
        }
    }
}

#Preview {
    LaunchScreenView()
}
