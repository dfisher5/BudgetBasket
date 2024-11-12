//
//  Search.swift
//  BudgetBasket
//
//  Created by Delaney Fisher on 10/15/24.
//

import Foundation

struct Store : Hashable {
    var storeName: String = ""
    var price: Double = 0.0
    var temporaryPrice: Bool = false
    var priceGoodThrough: String = ""
    
    init(storeName: String, price: Double) {
        self.storeName = storeName
        self.price = price
    }
    
    init(storeName: String, price: Double, priceGoodThrough: String) {
        self.storeName = storeName
        self.price = price
        self.priceGoodThrough = priceGoodThrough
        self.temporaryPrice = true
    }
}

class GroceryItem: Identifiable {
    let id: UUID = UUID()
    var itemName = ""
    var stores: [Store] = []
    
    init(itemNumber: Int) {
        if itemNumber == 1 {
            itemName = "Plain bagels"
            let s1 = Store(storeName: "Hannaford", price: 2.39)
            let s2 = Store(storeName: "Trader Joe's", price: 2.49)
            stores = [s1, s2]
        } else if itemNumber == 2 {
            itemName = "Peanut butter"
            let s1 = Store(storeName: "Hannaford", price: 2.39)
            let s2 = Store(storeName: "Trader Joe's", price: 2.99)
            stores = [s1, s2]
        } else if itemNumber == 3 {
            itemName = "Butter"
            let s1 = Store(storeName: "Hannaford", price: 3.99)
            let s2 = Store(storeName: "Trader Joe's", price: 3.99)
            stores = [s1, s2]
        } else if itemNumber == 4 {
            itemName = "Sour cream"
            let s1 = Store(storeName: "Hannaford", price: 1.59)
            let s2 = Store(storeName: "Trader Joe's", price: 2.79)
            stores = [s1, s2]
        } else if itemNumber == 5 {
            itemName = "Chocolate milk"
            let s1 = Store(storeName: "Hannaford", price: 2.69)
            let s2 = Store(storeName: "Trader Joe's", price: 3.99)
            stores = [s1, s2]
        } else if itemNumber == 6 {
            itemName = "Macaroni and cheese"
            let s1 = Store(storeName: "Hannaford", price: 0.57)
            let s2 = Store(storeName: "Trader Joe's", price: 0.99)
            stores = [s1, s2]
        } else if itemNumber == 7 {
            itemName = "Coconut oil"
            let s1 = Store(storeName: "Hannaford", price: 7.89)
            let s2 = Store(storeName: "Trader Joe's", price: 4.99)
            stores = [s1, s2]
        } else if itemNumber == 8 {
            itemName = "Black beans"
            let s1 = Store(storeName: "Hannaford", price: 1.05)
            let s2 = Store(storeName: "Trader Joe's", price: 0.89)
            stores = [s1, s2]
        }
    }
    
    init(itemName: String, stores: [Store]) {
        self.itemName = itemName
        self.stores = stores
    }
    
    func addStore(store: Store) {
        stores.append(store)
    }
}
