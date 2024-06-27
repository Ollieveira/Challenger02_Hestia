//
//  Data.swift
//  Challenger02_Hestia
//
//  Created by Willys Oliveira on 08/05/24.
//

import Foundation

struct DietaryRestrictionsData {
    static let nonDairyFreeIngredients: Set<String> = [
        "Butter", "Cheese", "Cheese Curds", "Cheddar Cheese", "Clotted Cream", "Colby Jack Cheese", "Cream", "Creme Fraiche", "Cubed Feta Cheese", "Double Cream", "Feta", "Fromage Frais", "Full Fat Yogurt", "Ghee", "Goats Cheese", "Gouda Cheese", "Greek Yogurt", "Ice Cream", "Mascarpone", "Milk", "Mozzarella", "Mozzarella Balls", "Parmesan", "Parmesan Cheese", "Pecorino", "Ricotta", "Shredded Mexican Cheese", "Shredded Monterey Jack Cheese", "Single Cream", "Sour Cream", "Stilton Cheese", "Vegan Butter", "Yogurt", "Cream Cheese", "Brie", "Queijo Minas ralado", "Manteiga", "Queijo prato", "Leite condensado", "Creme de leite", "Queijo parmesão", "Manteiga", "Leite", "queijo mozzarella"
    ]
    static let nonGlutenFreeIngredients: Set<String> = [
        "Baguette", "Barley", "Breadcrumbs", "Bread Rolls", "Bulgur Wheat", "Ciabatta", "Couscous", "Crusty Bread", "Digestive Biscuits", "Flour", "Flour Tortilla", "Lasagne Sheets", "Macaroni", "Malt Vinegar", "Naan Bread", "Noodles", "Oatmeal", "Oats", "Pasta", "Pita Bread", "Rye", "Seitan", "Semolina", "Spaghetti", "Suet", "Tagliatelle", "Udon Noodles", "Wheat", "Whole Wheat", "Yeast", "Fettuccine", "Linguine Pasta", "Pappardelle Pasta", "Paccheri Pasta", "White Flour", "farinha de trigo", "biscoito de maisena", "farinha de rosca", "farinha de milho"
    ]
    static let nonEggFreeIngredients: Set<String> = [
        "Egg White", "Egg Yolks", "Eggs", " Eggs ",  "Eggs ", " Eggs", "Mayonnaise", "flax eggs", "ovos", "gemas", "ovos", "ovos", "ovos", "ovos", "ovos", "gema de ovo", "ovos cozidos", "maionese"
    ]
    static let nonVeganIngredients: Set<String> = [
        "Butter", "Cheese", "Cheese Curds", "Cheddar Cheese", "Chicken", "Clotted Cream", "Colby Jack Cheese", "Cream", "Creme Fraiche", "Cubed Feta Cheese", "Double Cream", "Duck", "Egg White", "Egg Yolks", "Eggs", "Feta", "Fish Sauce", "Fromage Frais", "Full Fat Yogurt", "Gelatine Leafs", "Ghee", "Goat Meat", "Goats Cheese", "Gouda Cheese", "Greek Yogurt", "Honey", "Ice Cream", "Italian Fennel Sausages", "Jelly", "Kielbasa", "King Prawns", "Lamb", "Lamb Loin Chops", "Lamb Mince", "Mackerel", "Mascarpone", "Milk", "Mozzarella", "Mozzarella Balls", "Parmesan", "Parmesan Cheese", "Pecorino", "Pork", "Prawns", "Prosciutto", "Raw King Prawns", "Ricotta", "Salmon", "Shredded Mexican Cheese", "Shredded Monterey Jack Cheese", "Single Cream", "Smoked Haddock", "Smoked Salmon", "Sour Cream", "Squid", "Stilton Cheese", "Tuna", "White Fish", "White Fish Fillets", "Yogurt", "Cream Cheese", "Brie", "Beef", "Bacon", "Beef Brisket", "Beef Fillet", "Beef Gravy", "Beef Stock", "Chicken Breast", "Chicken Breasts", "Chicken Legs", "Chicken Stock", "Chicken Thighs", "Chorizo", "Doner Meat", "Duck Legs", "queijo Minas ralado", "manteiga", "ovos", "bacon", "carne seca", "linguiça calabresa", "queijo prato", "leite condensado", "creme de leite", "queijo parmesão", "camarão", "camarão seco", "manteiga", "ovos", "camarão", "camarão limpo", "camarão seco", "carne de siri", "queijo parmesão", "carne moída", "frango", "camarão", "carne bovina (cubos)", "peito de frango", "sardinha", "Peixe (robalo ou garoupa)", "carne seca desfiada", "Peixe (robalo ou dourado)"
    ]
    static let nonSeafoodFreeIngredients: Set<String> = [
        "Fish Sauce", "King Prawns", "Mackerel", "Prawns", "Raw King Prawns", "Smoked Haddock", "Smoked Salmon", "Squid", "Tuna", "White Fish", "White Fish Fillets", "Salmon", "Mussels", "Oysters", "Fish Stock", "camarão", "camarão seco", "camarão seco", "camarão limpo", "sardinha", "carne de siri", "Peixe (robalo ou garoupa)", "Peixe (robalo ou dourado)"
    ]
    static let nonPeanutFreeIngredients: Set<String> = [
        "Peanuts", "Peanut Butter", "Peanut Oil", "Peanut Cookies", "Peanut Brittle", "amendoim moído"
    ]
    static let nonSoyFreeIngredients: Set<String> = [
        "Soy Sauce", "Soya Milk", "molho de soja"
    ]
    static let nonSugarFreeIngredients: Set<String> = [
        "Sugar", "Brown Sugar", "Brown Sugar", "Caster Sugar", "Coco Sugar", "Condensed Milk", "Dark Brown Sugar", "Dark Soft Brown Sugar", "Demerara Sugar", "Granulated Sugar", "Honey", "Icing Sugar", "Light Brown Soft Sugar", "Maple Syrup", "Muscovado Sugar", "Powdered Sugar", "Golden Syrup", "açúcar", "leite condensado", "açúcar", "açúcar", "açúcar e canela para polvilhar"
    ]
}
