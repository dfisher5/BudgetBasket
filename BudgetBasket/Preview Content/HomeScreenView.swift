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
    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack {
                    if (screen == .shoppingList) {
                        GroceryListView()
                    }
                    else if (screen == .search) {
                        SearchView()
                    }
                    else if (screen == .cart) {
                        CartView().environmentObject(ItemStore())
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
    }
}

#Preview {
    HomeScreenView()
}
