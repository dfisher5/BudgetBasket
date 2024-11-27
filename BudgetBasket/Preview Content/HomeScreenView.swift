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
    case logout
}

struct HomeScreenView: View {
    @EnvironmentObject var viewModel: Authentication
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
                
                // Sale price
                for s in stores {
                    storesToAdd.append(Store(storeName: s["name"] as! String, price: s["price"] as! Double, salePrice: s["temporaryPrice"] as! Bool))
                }
                
                // Image
                var itemImage = d.data()["image"] as! String
                
                itemStore.addItem(item: GroceryItem(itemName: itemName, stores: storesToAdd, itemImage: itemImage))
            }
            
        }
        
    }
    
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                if viewModel.authenticationState == .unauthenticated {
                    Spacer()
                    LoginView()
                    Spacer()
                } else {
                    // Tab View
                    Spacer()
                    TabView() {
                        Group {
                            // Grocery List View
                            GroceryListView().environmentObject(itemStore)
                                .tabItem() {
                                    Image(systemName: "list.bullet.rectangle")
                                        .padding(.bottom, -20)
                                }
                            // Search
                            SearchView().environmentObject(itemStore)
                                .tabItem() {
                                    Image(systemName: "magnifyingglass")
                                        .padding(.bottom, -20)
                                }
                            // Cart
                            CartView().environmentObject(itemStore)
                                .tabItem() {
                                    Image(systemName: "cart")
                                        .padding(.bottom, -20)
                                }
                            // Logout
                            LogoutView().environmentObject(itemStore)
                                .tabItem() {
                                    Image(systemName: "person.circle.fill")
                                }
                        }
                    }
                }
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
    HomeScreenView().environmentObject(Authentication())
}
