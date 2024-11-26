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
    var salePrice: Bool = false
    
    init(storeName: String, price: Double) {
        self.storeName = storeName
        self.price = price
    }
    
    init(storeName: String, price: Double, salePrice: Bool) {
        self.storeName = storeName
        self.price = price
        self.salePrice = salePrice
    }
}

class GroceryItem: Identifiable {
    let id: UUID = UUID()
    var itemName = ""
    var stores: [Store] = []
    var itemImage = ""
    
    init(itemName: String, stores: [Store], itemImage: String) {
        self.itemName = itemName
        self.stores = stores
        self.itemImage = itemImage
    }
    
    func addStore(store: Store) {
        stores.append(store)
    }
}
