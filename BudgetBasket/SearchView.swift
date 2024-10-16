// SearchView.swift
// BudgetBasket
//
// Created by Delaney Fisher on 10/14/24.
//

import SwiftUI
 
struct SearchView: View {
    @StateObject var itemStore = ItemStore()

    var body: some View {
        List(itemStore.allItems) { item in
            VStack() {
                Text(item.itemName)
                ForEach(item.stores, id: \.storeName) { store in
                    Text("\(store.storeName): $\(store.price, specifier: "%.2f")")
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
