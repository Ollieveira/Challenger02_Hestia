import Foundation
import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

func loadLocalMeals(from filename: String) -> [Meal] {
    guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let meals = try decoder.decode([Meal].self, from: data)
        return meals
    } catch {
        fatalError("Couldn't parse \(filename) as [Meal]:\n\(error)")
    }
}

