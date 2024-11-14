//
//  GroceryListView.swift
//  BudgetBasket
//
//  Created by Sarah Stevens
//

import SwiftUI

struct GroceryListView: View {
    @State private var itemToAdd: String = ""
    //@State private var groceryList: [String] = []
    @StateObject var itemStore = ItemStore()
    @State private var editing: Bool = false
    @State private var itemIndex: Int = 0
    @State private var fun: Int = 18
    @EnvironmentObject var groceryList: GroceryListWithQuantities
    //@StateObject private var sharedData = SharedData()
    
    //@EnvironmentObject var itemsWithQuantities: [itemQuantity]
    //@State var tempItems: [itemQuantity] = []
    
    //@State private var tempItem: itemQuantity?
    
    func addToList() {
        //groceryList.append(itemToAdd)
        //groceryList.itemsWithQuantities.append(itemQuantity(itemName: itemToAdd, quantity: 1))
        groceryList.itemsWithQuantities.append(GroceryListWithQuantities.itemQuantity(itemName: itemToAdd, quantity: 1))
    }
    
    var allItemNames: [String] {
        itemStore.allItems.map { $0.itemName }
    }
    
    func loadData() {
        //if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("groceryList.plist") {
                        //if let data = try? Data(contentsOf: url) {
                            //if let decodedGroceryList = try? PropertyListDecoder().decode(GroceryListWithQuantities.self, from: data) {
                                //groceryList = decodedGroceryList
                            //}
                        //}
                    //}
        if let data = UserDefaults.standard.data(forKey: "groceryList.itemsWithQuantities") {
            if let decodedData = try? JSONDecoder().decode([GroceryListWithQuantities.itemQuantity].self, from: data) {
                groceryList.itemsWithQuantities = decodedData
                    }
            }
    }
    
    func updateData() {
        if let encoded = try? JSONEncoder().encode(groceryList.itemsWithQuantities) {
                    UserDefaults.standard.set(encoded, forKey: "groceryList.itemsWithQuantities")
                }
    }
    //struct itemQuantity: Codable, Identifiable, Equatable, CustomStringConvertible {
        //var id = UUID()
        //var itemName: String
        //var quantity: Int
        
        //mutating func increaseQuantity(){
            //quantity += 1
        //}
        
        //mutating func decreaseQuantity(){
            //if quantity > 0 {
                //quantity -= 1
            //}
        //}
        
        //static func == (one: itemQuantity, two: itemQuantity) -> Bool {
                //one.itemName == two.itemName
        //}
        
        //var description: String {
            //return "\(quantity) \(itemName)"
        //}
    //}
    
    //func findItem(itemToFind: String) -> itemQuantity?{
        //for item in itemsWithQuantities{
            //if item.itemName == itemToFind{
                //return item
            //}
        //}
        //return nil
    //}
    
    func findItem(itemToFind: GroceryListWithQuantities.itemQuantity) -> Int?{
        return groceryList.itemsWithQuantities.firstIndex(where: {$0.id == itemToFind.id})
    }

    var body: some View {
        VStack() {
            NavigationStack {
                Toggle("Edit Mode", isOn: $editing) .padding()
                if editing {
                    List {
                        ForEach(groceryList.itemsWithQuantities, id: \.id) { item in
                            HStack {
                                //Text("\(item)")
                                NavigationLink {
                                    QuantityEditView(itemQuantity: item.quantity, itemName: item.itemName)
                                } label: {
                                    Text("\(item.quantity)" + " " + item.itemName)
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
                                //Text("\(item.quantity)" + " " + "\(item.itemName)")
                                Text("\(item.quantity)" + " " + item.itemName)
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
                //if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("groceryList.plist") {
                    //if let data = try? Data(contentsOf: url) {
                        //if let decodedValues = try? PropertyListDecoder().decode([String].self, from: data) {
                            //groceryList = decodedValues
                        //}
                    //}
                //}
                loadData()
                
            }
            .onChange(of: groceryList.itemsWithQuantities) {
                updateData()
                //updatedList in
                //if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("groceryList.plist") {
                    //if let encodedData = try? PropertyListEncoder().encode(updatedList) {
                        //try? encodedData.write(to: url, options: .atomic)
                    //}
                //}
            }
            
    }

}

//#Preview {
   // GroceryListView(items: ItemStore())
//}

struct GroceryView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryListView().environmentObject(GroceryListWithQuantities())
    }
}
