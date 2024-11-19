//
//  FirebaseFunctions.swift
//  BudgetBasket
//
//  Created by Delaney Fisher on 11/17/24.
//

import Foundation
import FirebaseFirestore


class FirebaseFunctions: ObservableObject {
    private let db = Firestore.firestore()
    
    func addNewEntry(item: [String: Any], stores: [[String: Any]]) {
        var itemWithStores = item
        itemWithStores["stores"] = stores
        
        let document = db.collection("items").addDocument(data: itemWithStores) { error in
            if let error = error {
                print("Error writing to Firestore: \(error.localizedDescription)")
            } else {
                print("success")
            }
        }
    }
}
