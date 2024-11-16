//
//  HomeScreenView.swift
//  BudgetBasket
//
//  Created by Corey Stark on 10/18/24.
//

import SwiftUI

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
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack {
                    if (screen == .shoppingList) {
                        GroceryListView().environmentObject(itemStore)
                    }
                    else if (screen == .search) {
                        SearchView().environmentObject(itemStore)
                    }
                    else if (screen == .cart) {
                        CartView().environmentObject(itemStore)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height - 50)
                
                
                // NAV BAR
                HStack {
                    Spacer()
                    
                    // GROCERY LIST
                    Button(action: {screen = .shoppingList} ) {
                        Image(systemName: "list.bullet.rectangle")
                            .foregroundStyle(.black)
                            .font(.title)
                    }
                    
                    Spacer()
                    
                    // SEARCH ICON
                    Button(action: {screen = .search} ) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.black)
                            .font(.title)
                    }
                    
                    Spacer()
                    
                    // CART ICON
                    Button(action: {screen = .cart} ) {
                        Image(systemName: "cart")
                            .foregroundStyle(.black)
                            .font(.title)
                    }
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width, height: 75)
                .background(Color.gray.opacity(0.3))
                
            }
        }.environmentObject(groceryList)
        .onChange(of: scenePhase) {
            updateData()
        }
    }
}

#Preview {
    HomeScreenView()
}
