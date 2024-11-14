//
//  GroceryListWithQuantities.swift
//  BudgetBasket
//
//  Created by Sarah Stevens on 11/13/24.
//

import SwiftUI

class GroceryListWithQuantities: ObservableObject {
    @Published var itemsWithQuantities: [itemQuantity] = []
    
    struct itemQuantity: Codable, Identifiable, Equatable, CustomStringConvertible {
        var id = UUID()
        var itemName: String
        var quantity: Int
        
        mutating func increaseQuantity(){
            quantity += 1
        }
        
        mutating func decreaseQuantity(){
            if quantity > 0 {
                quantity -= 1
            }
        }
        
        static func == (one: itemQuantity, two: itemQuantity) -> Bool {
                one.itemName == two.itemName
        }
        
        var description: String {
            return "\(quantity) \(itemName)"
        }
    }
}
