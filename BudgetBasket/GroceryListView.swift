//
//  GroceryListView.swift
//  BudgetBasket
//
//  Created by Sarah Stevens
//

import SwiftUI

struct GroceryListView: View {
    @State private var itemToAdd: String = ""
    @State private var groceryList: [String] = [""]
    @State private var listDisplay: String = ""
    
    func addToList() {
        groceryList.append(itemToAdd)
        listDisplay += itemToAdd
        listDisplay += "\n"
        listDisplay += "\n"
    }
    
    func removeFromList() {
        //groceryList.removeAll(where: { $0 == })
    }
    
    func printList() {
        for item in groceryList {
            listDisplay += item
        }
    }

    var body: some View {
        VStack() {
            HStack {
                Text("Grocery List").font(.largeTitle).padding(.leading, 25)
                Spacer()
            }.padding(.top, 25)
           
            VStack(spacing: 30) {
                TextField("Item Name", text: $itemToAdd).padding(.trailing, 30).padding(.leading, 30).textFieldStyle(.roundedBorder)
                Button("Add Item") {
                    addToList() }
                VStack() {
                    HStack() {
                        Text(listDisplay).padding(.trailing, 30).padding(.leading, 30)
                        Spacer()
                    }
                }
                Spacer()
            }
            
        }.padding()
    }
}

#Preview {
    GroceryListView()
}
