//
//  AddNewRecipeView.swift
//  Challenger02_Hestia
//
//  Created by Guilherme Avila on 02/06/24.
//

import SwiftUI
import TelemetryClient

struct AddNewRecipeView: View {
    
//    @EnvironmentObject var purchaseManager: PurchaseManager
    @State var viewModel = MealViewModel.instance
    @State private var isShowingSheet = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack{
                    HStack (spacing:0){
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
                    HStack{
                        Text("Que maravilhas você deseja hoje?")
                    }
                    .font(.title2)
                    .fontDesign(.rounded)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 40)
                .padding(.top, 16)
                
                Image("HestiaMainPage")
                    .resizable()

                HStack {
                    Button(action: {
                        isShowingSheet.toggle()
                        TelemetryManager.send("ButtonClicked", with: ["Button": "Purchase"])

                    }) {
                        HStack{
//                            Text("\(purchaseManager.coins)")
//                                .foregroundStyle(.white)
//                                .bold()
                            Image("Receitokens")
                        }
                        .padding(10)
                        .padding(.horizontal, 16)
                        .background{
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.yellow)
                        }
                        
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
                .padding(.bottom, 20)
                
                HStack {
                    NavigationLink(destination: AddRecipeManually(viewModel: viewModel)) {
                        RoundedButtonView(imageName: "plus.circle.fill", title: "Criar", backgroundColor: Color.bgFavCardCor, iconColor: Color.tabViewCor, width: geometry.size.width / 2.5, custo: nil, receitokens: nil)
                        
                        Spacer()
                        
                        NavigationLink(destination: OCRView()) {
                            RoundedButtonView(imageName: "camera.fill", title: "Foto", backgroundColor: Color.bgFavCardCor, iconColor: Color.tabViewCor, width: geometry.size.width / 2.5, custo: 1, receitokens: "Receitokens")
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                
                HStack {
                    NavigationLink(destination: WebScrapingView()) {
                        RoundedButtonView(imageName: "link.circle.fill", title: "Link", backgroundColor: Color.bgFavCardCor, iconColor: Color.tabViewCor, width: geometry.size.width / 2.5, custo: 2, receitokens: "Receitokens")
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                
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
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(backgroundColor)
                    .frame(width: width, height: width)
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width / 3, height: width / 3)
                    .foregroundColor(iconColor)
                if let custo = custo, let receitokens = receitokens {
                    HStack {
                        Text("\(custo)")
                            .foregroundStyle(.white)
                            .bold()
                        Image(receitokens)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                    }
                    .padding(4)
                    .padding(.horizontal, 12)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.yellow)
                    }
                    .offset(x: -40, y: 60)
                    
                }
            }
            
            Text(title)
                .fontDesign(.rounded)
                .font(.body)
        }
    }
}

struct AddNewRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewRecipeView()
    }
}
