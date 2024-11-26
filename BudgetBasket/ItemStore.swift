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
    }
    
    func addItem(item : GroceryItem) {
        allItems.append(item)
    }
}
