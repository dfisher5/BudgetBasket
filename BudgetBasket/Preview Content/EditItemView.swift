//
//  EditItemView.swift
//  BudgetBasket
//
//  Created by Delaney Fisher on 10/31/24.
//

import SwiftUI
import PhotosUI

struct EditItemView: View {
    // VARIABLES
    var passedItemName: String
    @State private var itemName = ""
    @State private var itemPriceStr = ""
    @State private var store : String = "Hannaford"
    @State private var salePrice : Bool = false
    @State private var itemAdded : Bool = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var editedStores = [[String: Any]]()
    @State private var editedImage = ""
    let storeOptions : [String] = ["Hannaford", "Trader Joe's", "Shaw's", "Price Chopper"]
    let salePriceOptions : [Bool] = [true, false]
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var items : ItemStore
    @EnvironmentObject var redrawFlag : RedrawFlag
    @EnvironmentObject var fb : FirebaseFunctions
    @EnvironmentObject var image : ImageFunctions
    
    private var price : Double { Double(itemPriceStr) ?? 0.0}
    
    // VALIDATION OF PRICE
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    // HELPER FUNC TO EDIT ITEM
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
                // Check if image has changed, update editedImage if it has
                editedImage = items.allItems[i].itemImage
                let compressedImage = image.compressImage(image: image.selectedImage ?? UIImage()) ?? "n/a"
                if (items.allItems[i].itemImage != compressedImage) {
                    editedImage = compressedImage
                    items.allItems[i].itemImage = editedImage
                }
            }
        }
        fb.editEntry(item: passedItemName, stores: editedStores, image: editedImage)
        // CLOSE VIEW
        redrawFlag.increment()
        dismiss()
    }
    
    
    var body: some View {
        // CONTAINER
        ScrollView {
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
                        
                        // PHOTO PICKER
                        if let imageSelection = image.selectedImage {
                            Image(uiImage: imageSelection)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 200, maxHeight: 200)
                                .clipped()
                                .padding(.leading, 30)
                                .padding(.bottom, 25)
                        } else if let existingImageData = Data(base64Encoded: passedItem.itemImage),
                                  let existingImage = UIImage(data: existingImageData) {
                            Image(uiImage: existingImage)
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
                        }
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
    EditItemView(passedItemName: "Plain bagels").environmentObject(ItemStore()).environmentObject(FirebaseFunctions()).environmentObject(ImageFunctions())
}
