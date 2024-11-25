//
//  EditItemView.swift
//  BudgetBasket
//
//  Created by Delaney Fisher on 10/31/24.
//

import SwiftUI

struct EditItemView: View {
    // VARIABLES
    var passedItemName: String
    @State private var itemName = ""
    @State private var itemPriceStr = ""
    @State private var store : String = "Hannaford"
    @State private var salePrice : Bool = false
    @State private var itemAdded : Bool = false
    @State private var editedStores = [[String: Any]]()
    let storeOptions : [String] = ["Hannaford", "Trader Joe's", "Shaw's", "Price Chopper"]
    let salePriceOptions : [Bool] = [true, false]
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var items : ItemStore
    @EnvironmentObject var redrawFlag : RedrawFlag
    @EnvironmentObject var fb : FirebaseFunctions
    
    private var price : Double { Double(itemPriceStr) ?? 0.0}
    
    // VALIDATION OF PRICE
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    // HELPER FUNC TO ADD ITEM
    func editItem() {
        // Find the item to change prices of
        for i in items.allItems.indices {
            if (items.allItems[i].itemName == passedItemName) {
                // Go through the stores and find the correct one
                for j in items.allItems[i].stores.indices {
                    if (items.allItems[i].stores[j].storeName == store) {
                        items.allItems[i].stores[j].price = price
                        items.allItems[i].stores[j].salePrice = salePrice
                    }
                    let updatedStore: [String: Any] = [
                        "name": items.allItems[i].stores[j].storeName,
                        "price": items.allItems[i].stores[j].price,
                        "temporaryPrice": items.allItems[i].stores[j].salePrice
                    ]
                    editedStores.append(updatedStore)
                }
            }
        }
        fb.editEntry(item: passedItemName, stores: editedStores)
        // CLOSE VIEW
        redrawFlag.increment()
        dismiss()
    }
        
        
    var body: some View {
        // CONTAINER
            GeometryReader { geo in
                VStack {
                    if let passedItem = itemToDisplay {
                        VStack {
                            // TITLE
                            HStack {
                                Text("Edit Item").font(.title).padding(.leading, 25)
                                Spacer()
                            }
                                .padding(.bottom, 25)
                                .padding(.top, 10)
                            Spacer()
                            
                            
                            // ITEM NAME
                            Text(passedItem.itemName).font(.title3)
                            Spacer()
                            
                            // PRICE
                            VStack {
                                HStack{
                                    // Item name
                                    Text("Price").font(.title3)
                                    Spacer()
                                }
                                TextField(String(format: "%.2f", passedItem.stores.first(where: { $0.storeName == store })?.price ?? 0.00), text: $itemPriceStr).padding(.trailing, 30)
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
                                Button(action : {editItem()}) {
                                    Text("Save changes")
                                        .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                                        .background(Color.theme.accent)
                                        .foregroundStyle(.white)
                                        .overlay(RoundedRectangle(cornerRadius: 10.0).stroke(Color.theme.accent, lineWidth: 2))
                                        .cornerRadius(15)
                                }
                            }.padding()
                        }.frame(width: geo.size.width, height: geo.size.height)
                    } else {
                        Text("Item not found")
                    }
                }
            }
        }
        var itemToDisplay: GroceryItem? {
            items.allItems.first(where: { $0.itemName == passedItemName })
        }
    }

#Preview {
    EditItemView(passedItemName: "Plain bagels").environmentObject(ItemStore()).environmentObject(FirebaseFunctions())
}
