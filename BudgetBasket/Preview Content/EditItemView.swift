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
    @State private var tempPrice : Bool = false
    @State private var date : Date = Date()
    @State private var itemAdded : Bool = false
    let storeOptions : [String] = ["Hannaford", "Trader Joe's", "Shaws", "City Market"]
    let tempPriceOptions : [Bool] = [true, false]
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var items : ItemStore
    
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
            print(items.allItems[i].itemName)
            print(passedItemName)
            if (items.allItems[i].itemName == passedItemName) {
                // Go through the stores and find the correct one
                for j in items.allItems[i].stores.indices {
                    if (items.allItems[i].stores[j].storeName == store) {
                        items.allItems[i].stores[j].price = price
                        print(items.allItems[i].stores[j].price)
                    }
                }
            }
        }
        // CLOSE VIEW
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
                            }.padding(.bottom, 25)
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
                                    Text("Temporary Price?")
                                        .padding(.trailing, 10)
                                    Picker(
                                        "No Selection",
                                        selection: $tempPrice) {
                                            ForEach(tempPriceOptions, id: \.self) { option in
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
                            
                            // PRICE GOOD UNTIL
                            VStack {
                                HStack {
                                    Text(!tempPrice ? "Price Good" : "Price Good Until").foregroundStyle(!tempPrice ? .gray : .black)
                                    Spacer()
                                }
                                HStack {
                                    if (tempPrice) {
                                        DatePicker(
                                            "",
                                            selection: $date,
                                            displayedComponents: .date)
                                    } else {
                                        Text("Indefinitley").foregroundStyle(.gray)
                                    }
                                    Spacer()
                                }
                                .labelsHidden()
                                .padding()
                                .frame(height: 50)
                            }
                            .padding(.leading, 30)
                            .padding(.bottom, 25)
                            Spacer()
                            
                            // ADD BUTTON
                            VStack {
                                Button(action : {editItem()}) {
                                    Text("Save changes")
                                        .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                                        .background(.blue)
                                        .foregroundStyle(.white)
                                        .overlay(RoundedRectangle(cornerRadius: 10.0).stroke(.blue, lineWidth: 2))
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
    EditItemView(passedItemName: "Plain bagels").environmentObject(ItemStore())
}
