import SwiftUI

// Estrutura para conformar 'Identifiable'
struct AlertMessage: Identifiable {
    var id: String { message }
    let message: String
}

struct CoinListView: View {
    @EnvironmentObject var purchaseManager: PurchaseManager
    @State private var errorMessage: AlertMessage?

    var body: some View {
        NavigationView {
            VStack {
                Text("Coins: \(purchaseManager.coins)")
                    .font(.largeTitle)
                    .padding()

                Spacer()
            }
            .navigationTitle("User Coins")
            .alert(item: $errorMessage) { errorMessage in
                Alert(title: Text("Error"), message: Text(errorMessage.message), dismissButton: .default(Text("OK")))
            }
        }
    }
}
