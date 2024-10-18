//
//  NavBarView.swift
//  BudgetBasket
//
//  Created by Corey Stark on 10/18/24.
//

import SwiftUI

struct NavBarView: View {
    @State private var random : Int = 0
    @EnvironmentObject var screen : ScreenTracker
    
    var body: some View {
        HStack {
            Spacer()
            
            // GROCERY LIST
            Button(action: {screen.curScreen = .shoppingList} ) {
                Image(systemName: "list.bullet.rectangle")
                    .foregroundStyle(.black)
                    .font(.title)
            }
            
            Spacer()
            
            // SEARCH ICON
            Button(action: {screen.curScreen = .search} ) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.black)
                    .font(.title)
            }
            
            Spacer()
            
            // CART ICON
            Button(action: {screen.curScreen = .cart} ) {
                Image(systemName: "cart")
                    .foregroundStyle(.black)
                    .font(.title)
            }
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width, height: 75)
        .background(Color.gray.opacity(0.3))
    }
}

#Preview {
    NavBarView()
}
