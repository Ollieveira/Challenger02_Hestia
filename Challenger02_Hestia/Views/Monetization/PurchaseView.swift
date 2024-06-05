//
//  PurchaseView.swift
//  Challenger02_Hestia
//
//  Created by Willys Oliveira on 05/06/24.
//

import SwiftUI

struct PurchaseView: View {
    
    @State var receitokens: Int = 00
    @EnvironmentObject var purchaseManager: PurchaseManager
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Adquira mais Receitokens")
                    Text("Selecione abaixo sua oferta")
                }
                HStack {
                   Image("Receitokens")
                    Text("\(purchaseManager.coins)")
                }
            }
            .frame(maxWidth: .infinity)
            .border(.red)
            
            HStack {
                Button(action: {
                    purchaseManager.buyProduct(productIdentifier: "product_id_5_moedas")
                }, label: {
                    VStack {
                        HStack {
                            Text("5")
                            Image("Receitokens")
                        }
                        Text("Receitokens")
                        Text("R$ 1,00")
                    }
                })
                
                Button(action: {
                    purchaseManager.buyProduct(productIdentifier: "product_id_15_moedas")
                }, label: {
                    VStack {
                        HStack {
                            Text("15")
                            Image("Receitokens")
                        }
                        Text("Receitokens")
                        Text("R$ 2,90")
                    }
                })
                
                Button(action: {
                    purchaseManager.buyProduct(productIdentifier: "product_id_30_moedas")
                }, label: {
                    VStack {
                        HStack {
                            Text("30")
                            Image("Receitokens")
                        }
                        Text("Receitokens")
                        Text("R$ 4,90")
                    }
                })


            }
            .frame(maxWidth: .infinity)
            .border(.red)

        }
    }
}

#Preview {
    PurchaseView()
}
