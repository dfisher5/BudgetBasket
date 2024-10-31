//
//  GroceryListView.swift
//  BudgetBasket
//
//  Created by Sarah Stevens
//

import SwiftUI

struct GroceryListView: View {
    @State private var itemToAdd: String = ""
    @State private var defaultView: [String] = []
    @State private var groceryList: [String] = []
    //@ObservedObject var items : ItemStore
    @StateObject var itemStore = ItemStore()
    @State private var searching: Bool = false
    @State private var editing: Bool = false
    
    func addToList() {
        groceryList.append(itemToAdd)
    }
    
    var allItemNames: [String] {
        itemStore.allItems.map { $0.itemName }
    }
    
   // var searchResults: [String] {
        //if itemToAdd.isEmpty {
            //return groceryList
        //} else {
            //return allItemNames.filter { $0.lowercased().contains(itemToAdd) }
        //}
    //}

    var body: some View {
        VStack() {
            NavigationStack {
                Toggle("Edit Mode", isOn: $editing) .padding()
                if editing {
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
                } else {
                    List {
                        ForEach(groceryList, id: \.self) { item in
                            NavigationLink {
                                ItemDetailView(itemName: item).environmentObject(itemStore)
                            } label: {
                                Text(item)
                            }
                        }
                    }.searchable(text: $itemToAdd) {
                        ForEach(allItemNames.filter { $0.lowercased().contains(itemToAdd) }, id: \.self) { suggestion in
                            Button {
                                itemToAdd = suggestion
                                addToList()
                                itemToAdd = ""
                            } label: {
                                Text(suggestion)
                            }
                        }
                    }.textInputAutocapitalization(.never)
                        .navigationTitle("Grocery List")
                }
            }
            }.padding()
            .onAppear() {
                if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("groceryList.plist") {
                    if let data = try? Data(contentsOf: url) {
                        if let decodedValues = try? PropertyListDecoder().decode([String].self, from: data) {
                            groceryList = decodedValues
                        }
                    }
                }
            }
            .onChange(of: groceryList) { updatedList in
                if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("groceryList.plist") {
                    if let encodedData = try? PropertyListEncoder().encode(updatedList) {
                        try? encodedData.write(to: url, options: .atomic)
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
        GroceryListView()
    }
}
