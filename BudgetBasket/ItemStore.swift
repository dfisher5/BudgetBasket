//
//  ItemStore.swift
//  BudgetBasket
//
//  Created by Delaney Fisher on 10/15/24.
//
import Foundation

// Flag for changing item prices
class RedrawFlag : ObservableObject {
    @Published var counter = 0
    
    func increment() {
        counter += 1
    }
}


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
    
    func addItem(item : GroceryItem) {
        allItems.append(item)
    }
}
