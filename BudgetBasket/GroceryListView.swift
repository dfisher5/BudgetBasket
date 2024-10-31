//
//  GroceryListView.swift
//  BudgetBasket
//
//  Created by Sarah Stevens
//

import SwiftUI

struct GroceryListView: View {
    @State private var itemToAdd: String = ""
    @State private var selectedSuggestion: String?
    @State private var defaultView: [String] = []
    @State private var groceryList: [String] = []
    //@ObservedObject var items : ItemStore
    @StateObject var itemStore = ItemStore()
    @State private var searching: Bool = false
    //@State private var currentView: List
    
    func addToList() {
        groceryList.append(itemToAdd)
    }
    
    func editList(){
        
    }
    
    var allItemNames: [String] {
        itemStore.allItems.map { $0.itemName }
    }
    
    var searchResults: [String] {
        if itemToAdd.isEmpty {
            return groceryList
        } else {
            return allItemNames.filter { $0.lowercased().contains(itemToAdd) }
        }
    }

    var body: some View {
        VStack() {
           // HStack {
              //  Text("Grocery List").font(.largeTitle).padding(.leading, 25)
               // Spacer()
            //}.padding(.top, 25)
           
            //VStack(spacing: 30) {
                //TextField("Item Name", text: $itemToAdd).padding(.trailing, 30).padding(.leading, 30).textFieldStyle(.roundedBorder).textInputAutocapitalization(.never)
                //Button("Add Item") {
                    //addToList() }.padding(.horizontal, 100)
                    //.padding(.vertical, 10)
                    //.background(Color.blue)
                    //.foregroundColor(.white)
                    //.cornerRadius(10)
                    //.font(.title3)
                //VStack() {
                    //HStack() {
                        //Text(listDisplay).padding(.trailing, 30).padding(.leading, 30)
                        //Spacer()
                    //}
                //}
                //my original code
                //List {
                    //ForEach(groceryList, id: \.self) { string in Text(string) .swipeActions(edge: .trailing) {
                            //Button(role: .destructive) {
                                //groceryList.removeAll(where: { $0 == string })
                            //} label: {
                                //Label("Delete", systemImage: "trash")
                            //}
                        //}
                    //}
                //}
            NavigationStack {
                Button("Edit List") {
                    editList() }.padding(.horizontal, 100)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.title3)
                    List {
                        ForEach(groceryList, id: \.self) { item in
                            NavigationLink {
                                ItemDetailView(itemName: item).environmentObject(itemStore)
                            } label: {
                                Text(item)
                            }
                        }
                    }.searchable(text: $itemToAdd) {
                        ForEach(allItemNames.filter { $0.contains(itemToAdd) }, id: \.self) { suggestion in
                            Button {
                                itemToAdd = suggestion
                                selectedSuggestion = suggestion
                                addToList()
                                itemToAdd = ""
                            } label: {
                                Text(suggestion)
                            }
                        }
                    }.textInputAutocapitalization(.never)
                    .navigationTitle("Grocery List")
                }
            }.padding()
            .onAppear() {
                if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("groceryList.plist") {
                    if let data = try? Data(contentsOf: url) {
                        if let decodedValues = try? PropertyListDecoder().decode([String].self, from: data) {
                            groceryList = decodedValues
                        }
                    }
                }
            }
            .onChange(of: groceryList) { updatedList in
                if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("groceryList.plist") {
                    if let encodedData = try? PropertyListEncoder().encode(updatedList) {
                        try? encodedData.write(to: url, options: .atomic)
                    }
                }
            }
    }

}

//#Preview {
   // GroceryListView(items: ItemStore())
//}

struct GroceryView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryListView()
    }
}
