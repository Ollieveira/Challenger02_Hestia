import SwiftUI
import TelemetryClient

struct AddNewRecipeView: View {
    
    @EnvironmentObject var purchaseManager: PurchaseManager
    @State var viewModel = MealViewModel.instance
    @State private var isShowingSheet = false
    @State private var buttonPosition: CGRect = .zero

    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack {
                    HStack(spacing: 0) {
                        Text("Sejam bem-vindos ao")
                        Text(" Hestia")
                            .foregroundStyle(Color.tabViewCor)
                        Text("!")
                    }
                    .font(.title2)
                    .fontDesign(.rounded)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    
                    HStack {
                        Text("Que maravilhas você deseja hoje?")
                    }
                    .font(.title2)
                    .fontDesign(.rounded)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                }
                .padding(.top, 40)
                
                Image("HestiaMainPage")
                    .resizable()
                    .frame(width: 332, height: 340)
                    .padding(.top, 30)
                    
                HStack {
                    VStack(alignment: .leading) {
                        Text("Explore as funcionalidades ")
                        Text("esplendidas diante de ti!")
                    }
                    .font(.headline)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    
                    Spacer()
                    
                    Button(action: {
                        isShowingSheet.toggle()
                        TelemetryManager.send("ButtonClicked", with: ["Button": "Purchase"])
                    }) {
                        HStack {
                            Image("Receitokens")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 25)
                            
                             Text("\(purchaseManager.coins)")
                                 .font(.headline)
                                 .fontWeight(.regular)
                                 .foregroundStyle(Color.textCoin)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }
                    .sheet(isPresented: $isShowingSheet) {
                        PurchaseView()
                            .presentationDetents([.medium])
                            .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                            .presentationCornerRadius(44)
                            .presentationDragIndicator(.visible)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.top, 42)
                
                HStack(spacing: 26) {
                    NavigationLink(destination: WebScrapingView()) {
                        RoundedButtonView(imageName: "link.badge.plus", title: "Adicionar URL", backgroundColor: Color.backgroundCor, iconColor: Color.tabViewCor, width: geometry.size.width / 5, custo: 2, receitokens: "Receitokens", componentWidth: 100, height: 60)
                    }
                    .background(GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                DispatchQueue.main.async {
                                    self.buttonPosition = geo.frame(in: .global)
                                }
                            }
                    })
                    
                    NavigationLink(destination: AddRecipeManually(viewModel: viewModel)) {
                        RoundedButtonView(imageName: "note.text.badge.plus", title: "Crie sua receita", backgroundColor: Color.backgroundCor, iconColor: Color.tabViewCor, width: geometry.size.width / 5, custo: nil, receitokens: nil, componentWidth: 100, height: 60)
                    }
                    
                    NavigationLink(destination: OCRView()) {
                        RoundedButtonView(imageName: "photo.badge.plus.fill", title: "Adicionar foto", backgroundColor: Color.backgroundCor, iconColor: Color.tabViewCor, width: geometry.size.width / 5, custo: 1, receitokens: "Receitokens", componentWidth: 100, height: 60)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
            }
            .padding(.horizontal, 8)
        }
        .background(Color.backgroundCor)
    }
}

struct RoundedButtonView: View {
    let imageName: String
    let title: String
    let backgroundColor: Color
    let iconColor: Color
    let width: CGFloat
    let custo: Int?
    let receitokens: String?
    let componentWidth: CGFloat
    let height: CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width / 3, height: width / 3)
                    .foregroundColor(iconColor)
                if let custo = custo, let receitokens = receitokens {
                    HStack (spacing: 2){
                        Text("\(custo)")
                            .foregroundStyle(.orange)
                            .bold()
                        Image(receitokens)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                    }
                    .padding(1)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.backgroundCor)
                    }
                    .position(x: width / 1, y: width / 6) // Ajuste da posição baseado no tamanho do botão
                }
            }
            .frame(width: componentWidth, height: height)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
            
            VStack {
                Text(title)
                    .fontDesign(.rounded)
                    .font(.footnote)
                    .foregroundStyle(.filterUnactiveCor)
            }
            .frame(width: 100)
        }
    }
}

struct AddNewRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewRecipeView()
    }
}
