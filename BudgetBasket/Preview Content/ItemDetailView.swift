import SwiftUI

struct ItemDetailView: View {
    @EnvironmentObject var itemStore: ItemStore
    @EnvironmentObject var redrawFlag : RedrawFlag
    
    var itemName: String
    
    var body: some View {
            VStack {
                if let item = itemToDisplay {
                    VStack {
                        Text("\(item.itemName)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 20)
                            .frame(alignment: .leading)
                        Spacer()
                        
                        if let imageData = Data(base64Encoded: item.itemImage),
                           let decodedImage = UIImage(data: imageData) {
                            Image(uiImage: decodedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 250)
                        } else {
                            Text("Image unavailable")
                        }
                        
                        List {
                            ForEach(item.stores, id: \.self) { store in
                                if (store.price != 0.0) {
                                    StoreView(store: store)
                                }
                            }
                        }
                        NavigationLink(destination: EditItemView(passedItemName: itemName).environmentObject(itemStore).environmentObject(redrawFlag).environmentObject(FirebaseFunctions()).environmentObject(ImageFunctions())) {
                            Text("Edit item")
                                .padding(.horizontal, 100)
                                .padding(.vertical, 10)
                                .background(Color.theme.accent)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .font(.title3)
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .navigationBarTitleDisplayMode(.inline)
                    }
                } else {
                    Text("Item not found")
                }
        }/*.ignoresSafeArea(edges: .top)*/
//            .padding(.top, -70)
    }
    
    var itemToDisplay: GroceryItem? {
        itemStore.allItems.first(where: { $0.itemName == itemName })
    }
}

struct StoreView: View {
    var store: Store

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(store.storeName)
                .foregroundColor(.primary)
                .font(.headline)
            Text(String(format: "%.2f" + (store.salePrice ? " - Sale Price" : ""), store.price)) // Display formatted price
                .foregroundColor(store.salePrice ? Color.theme.accent : .secondary)
                .font(.subheadline)
        }
    }
}

#Preview {
    ItemDetailView(itemName: "Plain bagels").environmentObject(ItemStore())
}
