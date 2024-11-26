//
//  AddItemView.swift
//  BudgetBasket
//
//  Created by Corey Stark on 10/14/24.
//

import SwiftUI
import FirebaseFirestore
import PhotosUI

struct AddItemView: View {
    // VARIABLES
    @State private var itemName = ""
    @State private var itemPriceStr = ""
    @State private var store : String = "Hannaford"
    @State private var salePrice : Bool = false
    @State private var itemAdded : Bool = false
    @State private var selectedItem: PhotosPickerItem? = nil
    let storeOptions : [String] = ["Hannaford", "Trader Joe's", "Shaw's", "Price Chopper"]
    let salePriceOptions : [Bool] = [true, false]

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var items : ItemStore
    @EnvironmentObject var fb : FirebaseFunctions
    @EnvironmentObject var image : ImageFunctions
    
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
                
                // Sale price
                for s in stores {
                    storesToAdd.append(Store(storeName: s["name"] as! String, price: s["price"] as! Double, salePrice: s["temporaryPrice"] as! Bool))
                }
                let compressedImage = image.compressImage(image: image.selectedImage ?? UIImage()) ?? "n/a"
                items.addItem(item: GroceryItem(itemName: itemName, stores: storesToAdd, itemImage: compressedImage))
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
        let compressedImage = image.compressImage(image: image.selectedImage ?? UIImage()) ?? "n/a"
        fb.addNewEntry(item: ["name": itemName], stores: storesToAdd, image: compressedImage)
        
        
        // Update Item Store
        Task {
            try await getAllItems()
        }
        
        // CLOSE VIEW
        dismiss()
    }
    
    
    var body: some View {
        
        // CONTAINER
        ScrollView {
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
                
                
                // PHOTO PICKER
                if let imageSelection = image.selectedImage {
                    Image(uiImage: imageSelection)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 200, maxHeight: 200)
                        .clipped()
                        .padding(.leading, 30)
                        .padding(.bottom, 25)
                }
                PhotosPicker(selection: $image.photoPickerSelection, matching: .images, label: {Text("Select image")})
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                
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
                
                
                // SALE PRICE
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
                    Text((items.allItems.first(where: { $0.itemName == itemName }) != nil) ? "Item already exists in the database" : " ").foregroundStyle(.red)
                    Button(action : {addItem()}) {
                            Text("Add Item")
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .frame(height: 35)
                            .buttonStyle(.borderedProminent)
                    }
                    .disabled(itemName.count < 1 || itemPriceStr.count < 1 || (items.allItems.first(where: { $0.itemName == itemName }) != nil))
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                }.padding()
            }
        }.onDisappear {
            // Reset the photo picker selection
            selectedItem = nil
            image.selectedImage = nil
        }
    }
}

#Preview {
    AddItemView().environmentObject(ItemStore()).environmentObject(FirebaseFunctions()).environmentObject(ImageFunctions())
}
