//
//  ItemStore.swift
//  BudgetBasket
//
//  Created by Delaney Fisher on 10/15/24.
//

import Foundation

class ItemStore: ObservableObject {
    @Published var allItems: [GroceryItem]
    
    init() {
        allItems = []
        allItems.append(GroceryItem(itemNumber: 1))
        allItems.append(GroceryItem(itemNumber: 2))
        allItems.append(GroceryItem(itemNumber: 3))
        allItems.append(GroceryItem(itemNumber: 4))
        allItems.append(GroceryItem(itemNumber: 5))
        allItems.append(GroceryItem(itemNumber: 6))
        allItems.append(GroceryItem(itemNumber: 7))
        allItems.append(GroceryItem(itemNumber: 8))
    }
}
