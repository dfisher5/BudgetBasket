//
//  StartScreenView.swift
//  BudgetBasket
//
//  Created by Corey Stark on 11/16/24.
//
// Code created following https://www.youtube.com/watch?v=0ytO3wCRKZU

import SwiftUI

struct StartScreenView: View {
    @State private var active = false
    @State private var iconSize = 0.3
    @State private var iconOpacity = 0.3
    
    
    
    var body: some View {
        if active {
            HomeScreenView()
                .transition(.slide)
        }
        else {
            VStack {
                VStack {
                    Image(systemName: "basket")
                        .font(.system(size: 65))
                        .foregroundColor(.cyan)
                        .padding(.bottom, 10)
                    Text("Budget Basket")
                        .font(.system(size: 35))
                        .foregroundColor(.black)
                }
                .scaleEffect(iconSize)
                .opacity(iconOpacity)
                .onAppear() {
                    withAnimation(.spring(response: 0.7, dampingFraction: 0.4, blendDuration: 0.0)) {
//                        .spring(response: 0.5)
                        self.iconSize = 1.0
                        self.iconOpacity = 1
                    }
                }
            }
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.active = true
                    }
                }
            }
        }
    }
}

#Preview {
    StartScreenView()
}
