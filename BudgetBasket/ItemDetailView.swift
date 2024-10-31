import SwiftUI

struct ItemDetailView: View {
    @EnvironmentObject var itemStore: ItemStore
    var itemName: String
    
    var body: some View {
        NavigationView {
            VStack {
                if let item = itemToDisplay {
                    VStack {
                        Text("\(item.itemName)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 20)
                            .frame(alignment: .leading)
                        Spacer()
                        List {
                            ForEach(item.stores, id: \.self) { store in
                                StoreView(store: store)
                            }
                        }
                        NavigationLink(destination: EditItemView().environmentObject(itemStore)) {
                            Text("Edit item")
                                .padding(.horizontal, 100)
                                .padding(.vertical, 10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .font(.title3)
                        }
                        .padding(.top, 10)
                    }
                } else {
                    Text("Item not found")
                }
            }
        }
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
            Text(String(format: "%.2f", store.price)) // Display formatted price
                .foregroundColor(.secondary)
                .font(.subheadline)
        }
    }
}

#Preview {
    ItemDetailView(itemName: "Plain bagels").environmentObject(ItemStore())
}
