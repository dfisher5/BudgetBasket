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
//                var han = Store(storeName: "Hannaford", price: (stores["Hannaford"] as! Dictionary<String, Any>)["price"] as! Double, salePrice: (stores["Hannaford"] as! Dictionary<String, Any>)["salePrice"] as! Bool)
//                
//                // Shaws
//                var shaws = Store(storeName: "Shaw's", price: (stores["Shaw's"] as! Dictionary<String, Any>)["price"] as! Double, salePrice: (stores["Shaw's"] as! Dictionary<String, Any>)["salePrice"] as! Bool)
//                
//                // Price Chopper
//                var pc = Store(storeName: "Price Chopper", price: (stores["Price Chopper"] as! Dictionary<String, Any>)["price"] as! Double, salePrice: (stores["Price Chopper"] as! Dictionary<String, Any>)["salePrice"] as! Bool)
//                
//                // Trader Joes
//                var tjs = Store(storeName: "Trader Joe's", price: (stores["Trader Joe's"] as! Dictionary<String, Any>)["price"] as! Double, salePrice: (stores["Trader Joe's"] as! Dictionary<String, Any>)["salePrice"] as! Bool)
                
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
//                VStack
//                    if (screen == .shoppingList) {
//                        GroceryListView().environmentObject(itemStore)
//                    }
//                    else if (screen == .search) {
//                        SearchView().environmentObject(itemStore)
//                    }
//                    else if (screen == .cart) {
//                        CartView().environmentObject(itemStore)
//                    }
//                }
//                .frame(width: geo.size.width, height: geo.size.height - 50)
//                
//                
//                // NAV BAR
//                HStack {
//                    Spacer()
//                    
//                    // GROCERY LIST
//                    Button(action: {screen = .shoppingList} ) {
//                        Image(systemName: "list.bullet.rectangle")
//                            .foregroundStyle(.black)
//                            .font(.title)
//                    }
//                    
//                    Spacer()
//                    
//                    // SEARCH ICON
//                    Button(action: {screen = .search} ) {
//                        Image(systemName: "magnifyingglass")
//                            .foregroundStyle(.black)
//                            .font(.title)
//                    }
//                    
//                    Spacer()
//                    
//                    // CART ICON
//                    Button(action: {screen = .cart} ) {
//                        Image(systemName: "cart")
//                            .foregroundStyle(.black)
//                            .font(.title)
//                    }
//                    Spacer()
//                }
//                .frame(width: UIScreen.main.bounds.width, height: 75)
//                .background(Color.gray.opacity(0.3))
//                
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
