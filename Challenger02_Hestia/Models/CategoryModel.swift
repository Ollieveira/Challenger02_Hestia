import Foundation

struct Category: Identifiable, Codable {
    let idCategory: String
    let strCategory: String
    let strCategoryThumb: URL
    let strCategoryDescription: String
    var id: String { idCategory }
}

struct CategoriesResponse: Codable {
    let categories: [Category]
}
