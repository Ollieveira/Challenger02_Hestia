import Foundation

class UserManager {
    static let shared = UserManager()
    
    private init() {}

    func initializeUserDefaults() {
        if UserDefaults.standard.object(forKey: "userCoins") == nil {
            UserDefaults.standard.set(10, forKey: "userCoins")
        }
    }

    func getUserCoins() -> Int {
        return UserDefaults.standard.integer(forKey: "userCoins")
    }

    func saveUserCoins(_ coins: Int) {
        UserDefaults.standard.set(coins, forKey: "userCoins")
    }
}
