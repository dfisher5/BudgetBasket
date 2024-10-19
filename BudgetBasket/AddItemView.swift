//
//  AddItemView.swift
//  BudgetBasket
//
//  Created by Corey Stark on 10/14/24.
//

import SwiftUI

struct AddItemView: View {
    // VARIABLES
    @State private var itemName = ""
    @State private var itemPriceStr = ""
    @State private var store : String = "Hannaford"
    @State private var tempPrice : Bool = false
    @State private var date : Date = Date()
    @State private var itemAdded : Bool = false
    let storeOptions : [String] = ["Hannaford", "Trader Joes", "Shaws", "City Market"]
    let tempPriceOptions : [Bool] = [true, false]
    @ObservedObject var items : ItemStore
    
    private var price : Double { Double(itemPriceStr) ?? 0.0}
    
    // VALIDATION OF PRICE
    let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()
    
    // HELPER FUNC TO ADD ITEM
    func addItem() {
        if (tempPrice) {
            let storeToAdd : [Store] = [Store(storeName: store, price: price, priceGoodThrough: DateFormatter().string(from: date))]
            items.addItem(item: GroceryItem(itemName: itemName, stores: storeToAdd))
        }
        else {
            let storeToAdd : [Store] = [Store(storeName: store, price: price)]
            items.addItem(item: GroceryItem(itemName: itemName, stores: storeToAdd))
        }
    }
    
    
    var body: some View {
        
        // CONTAINER
        GeometryReader { geo in
            VStack {
                // TITLE
                HStack {
                    Text("Add Item").font(.title).padding(.leading, 25)
                    Spacer()
                }.padding(.bottom, 25)
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
                    Button(action : {addItem()}) {
                        Text("Add Item")
                            .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                            .background(.blue)
                            .foregroundStyle(.white)
                            .overlay(RoundedRectangle(cornerRadius: 10.0).stroke(.blue, lineWidth: 2))
                            .cornerRadius(15)
                    }
                }.padding()
            }.frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

#Preview {
    AddItemView(items: ItemStore())
}
