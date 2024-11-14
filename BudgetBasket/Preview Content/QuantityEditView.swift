//
//  QuantityEditView.swift
//  BudgetBasket
//
//  Created by Sarah Stevens on 11/13/24.
//

import SwiftUI

struct QuantityEditView: View {
    @State var itemQuantity: Int
    @State var itemName: String
    @State var itemIndex: Int = 0
    @EnvironmentObject var groceryList: GroceryListWithQuantities
    
    func findItem(itemToFind: String) -> Int?{
        return groceryList.itemsWithQuantities.firstIndex(where: {$0.itemName == itemToFind})
    }
    
    func decreaseVal(){
        if itemQuantity > 0 {
            itemQuantity -= 1
        }
    }
        
    func increaseVal() {
        itemQuantity += 1
    }
    
    var body: some View {
        VStack(spacing: 100){
            Text("\(itemQuantity)")
                .fontWeight(.bold)
            HStack(spacing: 50) {
                Button("-") { decreaseVal() }
                Button("+") { increaseVal() }
            }
        }.font(.largeTitle)
            .onChange(of: itemQuantity){
                itemIndex = findItem(itemToFind: itemName) ?? itemIndex
                groceryList.itemsWithQuantities[itemIndex].quantity = itemQuantity
            }
        
    }
}

#Preview {
    QuantityEditView(itemQuantity: 1, itemName: "Butter").environmentObject(GroceryListWithQuantities())
}
