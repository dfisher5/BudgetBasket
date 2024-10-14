//
//  AddItemView.swift
//  BudgetBasket
//
//  Created by Corey Stark on 10/14/24.
//

import SwiftUI

struct AddItemView: View {
    var body: some View {
        @State var itemName = ""
        @State var itemPrice = 0.0
        @State var store : String = ""
        var storeOptions : [String] = ["Hannaford", "Trader Joes", "Shaws", "City Market"]
        
        // CONTAINER
        VStack {
            // TITLE
            HStack {
                Text("Add Item").font(.title).padding(.leading, 25)
                Spacer()
            }.padding(.bottom, 25)
            
            
            // ITEM NAME
            VStack {
                HStack{
                    // Item name
                    Text("Item Name").font(.title3)
                    Spacer()
                }
                TextField("Required", text: $itemName).padding(.trailing, 30)
            }
            .textFieldStyle(.roundedBorder)
            .padding(.leading, 30)
            .padding(.bottom, 25)
            
            
            // PRICE
            VStack {
                HStack{
                    // Item name
                    Text("Price").font(.title3)
                    Spacer()
                }
                TextField("Required", text: $itemName).padding(.trailing, 30)
            }
            .textFieldStyle(.roundedBorder)
            .padding(.leading, 30)
            .padding(.bottom, 25)
            
            
            // STORE
            VStack {
                HStack{
                    // Item name
                    Text("Store").font(.title3)
                    Spacer()
                }
                Picker(
                    "No Selection",
                    selection: $store) {
                        ForEach(storeOptions, id: \.self) {
                            Text("\($0)")
                        }
                    }
            }
            .padding(.leading, 30)
            
            
            Spacer()
        }
    }
}

#Preview {
    AddItemView()
}
