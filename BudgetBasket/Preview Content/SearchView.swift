// SearchView.swift
// BudgetBasket
//
// Created by Delaney Fisher on 10/14/24.
//

import SwiftUI
 
struct SearchView: View {
    @EnvironmentObject var itemStore : ItemStore
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            NavigationLink(destination: AddItemView().environmentObject(itemStore)) {
                    Text("Add item")
                    .padding(.horizontal, 100)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.title3)
                }
                List {
                    ForEach(searchResults, id: \.self) { item in
                        NavigationLink {
                            ItemDetailView(itemName: item).environmentObject(itemStore)
                        } label: {
                            Text(item)
                        }
                    }
                }.searchable(text: $searchText)
                .navigationTitle("Search Items")
            
        }.autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
    }
    
    var allItemNames: [String] {
        itemStore.allItems.map { $0.itemName }
    }
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return allItemNames
        } else {
            return allItemNames.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView().environmentObject(ItemStore())
    }
}
