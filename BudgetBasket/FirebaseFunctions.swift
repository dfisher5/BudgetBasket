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
        
        db.collection("items").addDocument(data: itemWithStores) { error in
            if let error = error {
                print("Error writing to Firestore: \(error.localizedDescription)")
            } else {
                print("success")
            }
        }
    }
    
    func editEntry(item: String, stores: [[String: Any]]) {
        Task {
            var itemWithStores: [String: Any] = [:]
            itemWithStores["name"] = item
            itemWithStores["stores"] = stores
            let storeData: [String: Any] = ["stores": stores]
            do {
                let query = try await self.db.collection("items").whereField("name", isEqualTo: item).getDocuments()
                let document = query.documents.first
                if let documentID = document?.documentID {
                    try await db.collection("items").document(documentID).setData(itemWithStores)
                }
            } catch {
                print("Error writing document: \(error)")
            }
        }
    }
}
