import SwiftUI

struct PurchaseCoinsView: View {
    @EnvironmentObject var purchaseManager: PurchaseManager
    
    var body: some View {
        List {
            Button(action: {
                purchaseManager.buyProduct(productIdentifier: "product_id_5_moedas")
            }) {
                Text("Buy 5 Coins")
            }
            Button(action: {
                purchaseManager.buyProduct(productIdentifier: "product_id_5_moedas")
            }) {
                Text("Buy 10 Coins")
            }
            Button(action: {
                purchaseManager.buyProduct(productIdentifier: "product_id_30_moedas")
            }) {
                Text("Buy 30 Coins")
            }
        }
        .navigationTitle("Purchase Coins")
    }
}
