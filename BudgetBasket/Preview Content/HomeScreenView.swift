//
//  HomeScreenView.swift
//  BudgetBasket
//
//  Created by Corey Stark on 10/18/24.
//

import SwiftUI
import FirebaseFirestore

enum ScreenToShow {
    case shoppingList
    case search
    case cart
    case addItem
}

struct HomeScreenView: View {
    @StateObject private var groceryList = GroceryListWithQuantities()
    @State var screen : ScreenToShow = .shoppingList
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var itemStore = ItemStore()
    
    @discardableResult
    func updateData() -> Bool {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(groceryList.itemsWithQuantities)
            try data.write(to: groceryList.groceryListURL, options: [.atomic])
            print("saved data to \(groceryList.groceryListURL)")
            return true
        } catch let encodingError {
            print("Error encoding allItems: \(encodingError)")
            return false
        }
    }
    
    func getAllItems() async throws {
        let dbItemStore = Firestore.firestore().collection("items")
        let docs = try await dbItemStore.getDocuments()
        for d in docs.documents {
            do {
                // Item name
                var itemName = d.data()["name"] as! String
                
                // Stores
                var stores = d.data()["stores"] as! Array<Dictionary<String, Any>>
                var storesToAdd = [Store]()
                
                // Hannaford
                for s in stores {
                    storesToAdd.append(Store(storeName: s["name"] as! String, price: s["price"] as! Double, salePrice: s["temporaryPrice"] as! Bool))
                }
                
                itemStore.addItem(item: GroceryItem(itemName: itemName, stores: storesToAdd))
            } 
            
        }
        
    }
    
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                // Tab View
                Spacer()
                TabView() {
                    // Grocery List View
                    GroceryListView().environmentObject(itemStore)
                        .tabItem() {
                            Image(systemName: "list.bullet.rectangle")
                        }
                    // Search
                    SearchView().environmentObject(itemStore)
                        .tabItem() {
                            Image(systemName: "magnifyingglass")
                        }
                    // Cart
                    CartView().environmentObject(itemStore)
                        .tabItem() {
                        Image(systemName: "cart")
                    }
                }
                .accentColor(.cyan)
            }
        }
            .navigationBarBackButtonHidden(true)
            .environmentObject(groceryList)
            .environmentObject(RedrawFlag())
            .ignoresSafeArea()
            .frame(height: UIScreen.main.bounds.height)
        .onChange(of: scenePhase) {
            updateData()
        }
        .onAppear() {
            Task {
                do {
                    try await getAllItems()
                } catch {
                    print("ERROR")
                }
            }
        }
    }
}

#Preview {
    HomeScreenView()
}
