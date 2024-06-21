import SwiftUI
import TelemetryClient

@main
struct Challenge2App: App {
    
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var purchaseManager = PurchaseManager.shared
    
    var body: some Scene {
        WindowGroup {
            TheTabView()
                .environmentObject(purchaseManager)
                .preferredColorScheme(.light)
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .background:
                do {
                    try MealViewModel.instance.meals.save(in: "meals")
                    try MealViewModel.instance.favoriteMeals.save(in: "favoriteMeals")
                    print("salvou")
                } catch {
                    print("Se ferrou!", error)
                }
            case .inactive:
                break
            case .active:
                break
            @unknown default:
                break
            }
        }
    }
    
    init() {
        let configuration = TelemetryManagerConfiguration(
            appID: "5465312F-7D61-413A-BA0E-9FC4E2438E10")
        TelemetryManager.initialize(with: configuration)
    }
}

#Preview {
    TheTabView()
}
