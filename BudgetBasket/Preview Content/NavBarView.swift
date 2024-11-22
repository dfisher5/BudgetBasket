//
//  NavBarView.swift
//  BudgetBasket
//
//  Created by Corey Stark on 10/18/24.
//

import SwiftUI

struct NavBarView: View {
//    @EnvironmentObject var screen : ScreenTracker
    @State var screen : ScreenToShow = .addItem
    
    var body: some View {
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
            
            // PROFILE ICON
            Button(action: {screen = .logout} ) {
                Image(systemName: "person.circle.fill")
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
