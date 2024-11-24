//
//  AddItemView.swift
//  BudgetBasket
//
//  Created by Corey Stark on 10/14/24.
//

import SwiftUI
import FirebaseFirestore

struct AddItemView: View {
    // VARIABLES
    @State private var itemName = ""
    @State private var itemPriceStr = ""
    @State private var store : String = "Hannaford"
    @State private var salePrice : Bool = false
    @State private var itemAdded : Bool = false
    let storeOptions : [String] = ["Hannaford", "Trader Joe's", "Shaw's", "Price Chopper"]
    let salePriceOptions : [Bool] = [true, false]

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var items : ItemStore
    @EnvironmentObject var fb : FirebaseFunctions
    
    private var price : Double { Double(itemPriceStr) ?? 0.0}
    
    // VALIDATION OF PRICE
    let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()
    
    func getAllItems()async throws {
        // Reset Item Store
        items.allItems = [GroceryItem]()
        
        let dbItemStore = Firestore.firestore().collection("items")
        let docs = try await dbItemStore.getDocuments()
        for d in docs.documents {
            do {
                // Item name
                var itemName = d.data()["name"] as! String
                
                // Stores
                var stores = d.data()["stores"] as! Array<Dictionary<String, Any>>
                var storesToAdd = [Store]()
                
                // Hannaford
                for s in stores {
                    storesToAdd.append(Store(storeName: s["name"] as! String, price: s["price"] as! Double, salePrice: s["temporaryPrice"] as! Bool))
                }
                
                items.addItem(item: GroceryItem(itemName: itemName, stores: storesToAdd))
            }
            
        }
        
    }
    
    // HELPER FUNC TO ADD ITEM
    func addItem() {
        // Make an array of all stores with prices 0.00
        var storesToAdd : [[String : Any]] = [["name" : "Hannaford", "price": 0.0, "temporaryPrice": false], ["name" : "Trader Joe's", "price": 0.0, "temporaryPrice": false], ["name" : "Shaw's", "price": 0.0, "temporaryPrice": false], ["name" : "Price Chopper", "price": 0.0, "temporaryPrice": false]]
        // Find the store they entered and edit the price
        for (index, var i) in storesToAdd.enumerated() {
            if let name = i["name"] as? String, name == store {
                i["price"] = price
                i["temporaryPrice"] = salePrice
                storesToAdd[index] = i
            }
        }
        fb.addNewEntry(item: ["name": itemName], stores: storesToAdd)
        
        
        // Update Item Store
        Task {
            try await getAllItems()
        }
        
        // CLOSE VIEW
        dismiss()
    }
    
    
    var body: some View {
        
        // CONTAINER
        GeometryReader { geo in
            VStack {
                // TITLE
                HStack {
                    Text("Add Item").font(.title).padding(.leading, 25)
                    Spacer()
                }
                    .padding(.bottom, 25)
                    .padding(.top, 10)
                Spacer()
                
                
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
                Spacer()
                
                
                // PRICE
                VStack {
                    HStack{
                        // Item name
                        Text("Price").font(.title3)
                        Spacer()
                    }
                    TextField("Required", text: $itemPriceStr).padding(.trailing, 30)
                        .decimalNumberOnly($itemPriceStr)
                }
                .textFieldStyle(.roundedBorder)
                .padding(.leading, 30)
                .padding(.bottom, 25)
                Spacer()
                
                
                // STORE
                VStack {
                    HStack{
                        // Item name
                        Text("Store").font(.title3)
                        Spacer()
                    }
                    HStack {
                        Picker(
                            "No Selection",
                            selection: $store) {
                                ForEach(storeOptions, id: \.self) {
                                    Text("\($0)")
                                }
                            }
                        Spacer()
                    }
                }
                .padding(.leading, 30)
                .padding(.bottom, 25)
                Spacer()
                
                
                // TEMPORARY PRICE
                VStack {
                    HStack {
                        Text("Sale Price?")
                            .padding(.trailing, 10)
                        Picker(
                            "No Selection",
                            selection: $salePrice) {
                                ForEach(salePriceOptions, id: \.self) { option in
                                    Text(option ? "Yes" : "No")
                                }
                            }
                            .pickerStyle(.segmented)
                    }
                }
                .padding(.leading, 30)
                .padding(.trailing, 30)
                .padding(.bottom, 25)
                Spacer()
                
                // ADD BUTTON
                VStack {
                    Button(action : {addItem()}) {
                            Text("Add Item")
                            .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                            .background(.blue)
                            .foregroundStyle(.white)
                            .overlay(RoundedRectangle(cornerRadius: 10.0).stroke(.blue, lineWidth: 2))
                            .cornerRadius(15)
                    }
                }.padding()
            }
                .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

#Preview {
    AddItemView().environmentObject(ItemStore()).environmentObject(FirebaseFunctions())
}
