//
//  PurchaseView.swift
//  Challenger02_Hestia
//
//  Created by Willys Oliveira on 05/06/24.
//

import SwiftUI

struct PurchaseView: View {
    
    @EnvironmentObject var purchaseManager: PurchaseManager
    
    var body: some View {
        VStack (spacing: 24) {
            HStack {
                VStack {
                    Text("Adquira mais Receitokens")
                        .font(.headline).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(Color.tabViewCor)
                    Text("Selecione abaixo sua oferta")
                        .font(.footnote).fontWeight(.regular)
                        .foregroundStyle(Color.tabViewCor)

                }
                HStack {
                   Image("Receitokens")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22,height: 25)

                    Text("\(purchaseManager.coins)")
                        .font(.headline).fontWeight(.regular)
                        .foregroundStyle(Color.textCoin)

                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray, lineWidth: 1)
                )

            }
            .frame(maxWidth: .infinity)
            
            
            HStack {
                Button(action: {
                    purchaseManager.buyProduct(productIdentifier: "product_id_5_moedas")
                }, label: {
                    VStack {
                        HStack (spacing: 1) {
                            Text("5")
                                .font(.largeTitle).fontWeight(.bold)
                                .foregroundStyle(Color.backgroundCor)

                            Image("Receitokens")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 36,height: 25)

                        }
                        Text("Receitokens")
                            .font(.footnote).fontWeight(.regular)
                            .foregroundStyle(Color.backgroundCor)

                        Text("R$ 0,99")
                            .padding(8)
                            .font(.body).fontWeight(.bold)
                            .foregroundStyle(Color.white)
                            .background(RoundedRectangle(cornerRadius: 6)
                                .fill(Color.backgroundPrice)
                            )

                    }
                    .padding()
                    .background{
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.tabViewCor)
                            .shadow(radius: 5)
                    }
                })
                
                Button(action: {
                    purchaseManager.buyProduct(productIdentifier: "product_id_15_moedas")
                }, label: {
                    VStack {
                        HStack (spacing: 1) {
                            Text("15")
                                .font(.largeTitle).fontWeight(.bold)
                                .foregroundStyle(Color.backgroundCor)

                            Image("Receitokens")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 36,height: 25)

                        }
                        Text("Receitokens")
                            .font(.footnote).fontWeight(.regular)
                            .foregroundStyle(Color.backgroundCor)

                        Text("R$ 2,90")
                            .padding(8)
                            .font(.body).fontWeight(.bold)
                            .foregroundStyle(Color.white)
                            .background(RoundedRectangle(cornerRadius: 6)
                                .fill(Color.backgroundPrice)
                            )

                    }
                    .padding()
                    .background{
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.tabViewCor)
                            .shadow(radius: 5)
                    }

                })
                
                Button(action: {
                    purchaseManager.buyProduct(productIdentifier: "product_id_30_moedas")
                }, label: {
                    VStack {
                        HStack (spacing: 1) {
                            Text("30")
                                .font(.largeTitle).fontWeight(.bold)
                                .foregroundStyle(Color.backgroundCor)

                            Image("Receitokens")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 36,height: 25)
                        }
                        Text("Receitokens")
                            .font(.footnote).fontWeight(.regular)
                            .foregroundStyle(Color.backgroundCor)

                        Text("R$ 4,99")
                            .padding(8)
                            .font(.body).fontWeight(.bold)
                            .foregroundStyle(Color.white)
                            .background(RoundedRectangle(cornerRadius: 6)
                                .fill(Color.backgroundPrice)
                            )

                    }
                    .padding()
                    .background{
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.tabViewCor)
                            .shadow(radius: 5)
                    }

                })


            }
            .frame(maxWidth: .infinity)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(RoundedRectangle(cornerRadius: 44)
            .fill(Color.backgroundCor)
        )
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    PurchaseView()
}
