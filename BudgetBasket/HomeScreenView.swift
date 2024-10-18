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
 
class ScreenTracker : ObservableObject {
    @Published var curScreen : ScreenToShow = .shoppingList
}

struct HomeScreenView: View {
    @StateObject var screen = ScreenTracker()
    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack {
                    if (screen.curScreen == .shoppingList) {
                        GroceryListView()
                    }
                    else if (screen.curScreen == .search) {
                        SearchView()
                    }
                    else if (screen.curScreen == .addItem) {
                        AddItemView()
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height - 50)
                
                NavBarView()
                
            }
        }
    }
}

#Preview {
    HomeScreenView()
}
