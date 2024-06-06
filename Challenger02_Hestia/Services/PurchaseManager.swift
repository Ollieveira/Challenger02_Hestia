import StoreKit

class PurchaseManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let shared = PurchaseManager()
    private var products: [SKProduct] = []
    private var productRequest: SKProductsRequest?

    @Published var coins: Int = 0

    override private init() {
        super.init()
        SKPaymentQueue.default().add(self)
        UserManager.shared.initializeUserDefaults()
        coins = UserManager.shared.getUserCoins()
        fetchProducts(productIdentifiers: ["product_id_5_moedas", "product_id_15_moedas", "product_id_30_moedas"])
    }

    func addCoins(_ amount: Int) {
        coins += amount
        saveCoins()
    }
    
    func useCoins(_ amount: Int) -> Bool {
        if coins >= amount {
            coins -= amount
            saveCoins()
            return true
        } else {
            return false
        }
    }

    private func saveCoins() {
        UserManager.shared.saveUserCoins(coins)
    }

    func fetchProducts(productIdentifiers: [String]) {
        productRequest = SKProductsRequest(productIdentifiers: Set(productIdentifiers))
        productRequest?.delegate = self
        productRequest?.start()
        print(products)
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
    }

    func buyProduct(productIdentifier: String) {
        print(products)
        guard let product = products.first(where: { $0.productIdentifier == productIdentifier }) else {
            print("Nao foi possivel localizar este produto")
            return
        }
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        print("pagamento feito")
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                if let productIdentifier = transaction.payment.productIdentifier as String? {
                    switch productIdentifier {
                    case "product_id_5_moedas":
                        addCoins(5)
                    case "product_id_15_moedas":
                        addCoins(15)
                    case "product_id_30_moedas":
                        addCoins(30)
                    default:
                        break
                    }
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                if let error = transaction.error as NSError?, error.code != SKError.paymentCancelled.rawValue {
                    print("Transaction failed: \(error.localizedDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
}
