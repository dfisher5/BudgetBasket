//
//  GroceryListView.swift
//  BudgetBasket
//
//  Created by Sarah Stevens
//

import SwiftUI

struct GroceryListView: View {
    @State private var itemToAdd: String = ""
    @EnvironmentObject var itemStore : ItemStore
    @State private var editing: Bool = false
    @State private var itemIndex: Int = 0
    @State private var fun: Int = 18
    @EnvironmentObject var redrawFlag : RedrawFlag
    @EnvironmentObject var groceryList: GroceryListWithQuantities
    
    func addToList() {
        groceryList.itemsWithQuantities.append(GroceryListWithQuantities.itemQuantity(itemName: itemToAdd, quantity: 1))
    }
    
    var allItemNames: [String] {
        itemStore.allItems.map { $0.itemName }
    }
    
    func findItem(itemToFind: GroceryListWithQuantities.itemQuantity) -> Int?{
        return groceryList.itemsWithQuantities.firstIndex(where: {$0.id == itemToFind.id})
    }

    var body: some View {
        ZStack {
            VStack() {
                NavigationStack {
                    Toggle("Edit Mode", isOn: $editing).padding()
                    if editing {
                        List {
                            ForEach(groceryList.itemsWithQuantities, id: \.id) { item in
                                HStack {
                                    NavigationLink {
                                        QuantityEditView(itemQuantity: item.quantity, itemName: item.itemName)
                                    } label: {
                                        Text("\(item.quantity) ").opacity(0.5)
                                        Text("\(item.itemName)")
                                    }.swipeActions(edge: .trailing){
                                        Button(role: .destructive){
                                            groceryList.itemsWithQuantities.removeAll(where: { $0 == item})
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        List {
                            ForEach(groceryList.itemsWithQuantities, id: \.id) { item in
                                NavigationLink {
                                    ItemDetailView(itemName: item.itemName).environmentObject(itemStore)
                                } label: {
                                    Text("\(item.quantity) ").opacity(0.5)
                                    Text("\(item.itemName)")
                                }
                            }
                        }.searchable(text: $itemToAdd) {
                            ForEach(allItemNames.filter { $0.localizedCaseInsensitiveContains(itemToAdd) }, id: \.self) { suggestion in
                                Button {
                                    itemToAdd = suggestion
                                    // If the item to add is already in the list increase the quantity
                                    if ((groceryList.itemsWithQuantities.first(where: {$0.itemName == itemToAdd})) == nil) {
                                        addToList()
                                    } else {
                                        for i in 0 ..< groceryList.itemsWithQuantities.count {
                                            if (groceryList.itemsWithQuantities[i].itemName == itemToAdd) {
                                                groceryList.itemsWithQuantities[i].increaseQuantity()
                                            }
                                        }
                                    }
                                    itemToAdd = ""
                                } label: {
                                    Text(suggestion)
                                }
                            }
                        }.textInputAutocapitalization(.never)
                            .navigationTitle("Grocery List")
                            .toolbarBackground(Color("Background"), for: .navigationBar)
                            .toolbarBackground(.visible, for: .navigationBar)
                    }
                }
            }
        }
    }

}

//#Preview {
   // GroceryListView(items: ItemStore())
//}

struct GroceryView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryListView().environmentObject(GroceryListWithQuantities()).environmentObject(ItemStore()).environmentObject(RedrawFlag())
    }
}
