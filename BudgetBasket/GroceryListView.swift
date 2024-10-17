//
//  GroceryListView.swift
//  BudgetBasket
//
//  Created by Sarah Stevens
//

import SwiftUI

struct GroceryListView: View {
    @State private var itemToAdd: String = ""
    @State private var groceryList: [String] = []
    @State private var listDisplay: String = ""
    //@State private var strings: [String] = []
    //var items: FetchedResults<Item>
    //@State private var items:
    
    func addToList() {
        groceryList.append(itemToAdd)
        listDisplay += itemToAdd
        listDisplay += "\n"
        listDisplay += "\n"
        //let newItem = NSSortDescriptor(key: itemToAdd, ascending: true)
        //items.nsSortDescriptors.append(newItem)
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
                //VStack() {
                    //HStack() {
                        //Text(listDisplay).padding(.trailing, 30).padding(.leading, 30)
                        //Spacer()
                    //}
                //}
                List {
                    ForEach(groceryList, id: \.self) { string in Text(string) .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                groceryList.removeAll(where: { $0 == string })
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
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
