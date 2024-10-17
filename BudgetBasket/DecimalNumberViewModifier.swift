//
//  DecimalNumberViewModifier.swift
//  BudgetBasket
//
//  Created by Corey Stark on 10/17/24.
//  CODE SOURCED FROM https://www.youtube.com/watch?v=dd079CQ4Fr4

import SwiftUI
import Combine

struct DecimalNumberViewModifier : ViewModifier {
    
    @Binding var text : String
    
    func body(content: Content) -> some View {
        content
            .keyboardType(.decimalPad)
            .onReceive(Just(text)) { newValue in
                let allowedChars = "0123456789."
                    
                if newValue.components(separatedBy: ".").count - 1 > 1 {
                    let filtered = newValue
                    self.text = String(filtered.dropLast())
                } else {
                    let filtered = newValue.filter { allowedChars.contains($0)}
                    if filtered != newValue {
                        self.text = filtered
                    }
                }
            }
    }
}

extension View {
    func decimalNumberOnly(_ text: Binding<String>) -> some View {
        self.modifier(DecimalNumberViewModifier(text: text))
    }
}
