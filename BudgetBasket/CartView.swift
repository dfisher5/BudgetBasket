//
//  CartView.swift
//  BudgetBasket
//
//  Created by Corey Stark on 11/7/24.
//

import SwiftUI

struct CartView: View {
    
    // [ HANAFORD, TRADER JOES, SHAWS, PRICE CHOPPER]
    
    
    @State private var numberOfStores : String = "1 Store"
    
    let numberOfStoreStops : [String] = ["1 Store", "2 Stores", "3 Stores", "4 Stores"]
    @EnvironmentObject var items : GroceryListWithQuantities
    @EnvironmentObject var itemStore : ItemStore
    
    @State private var prices = [[Double]]()
    @State private var itemNames = [String]()
    @State private var quantities = [String : Int]()
    
    private var intNumStores : Int { Int(numberOfStores.prefix(1)) ?? 1}
    
    func populateArrays() {
        // Go through each item in the list
        for item in items.itemsWithQuantities {
            itemNames.append(item.itemName)
            quantities[item.itemName] = item.quantity
            var itemToDisplay: GroceryItem {
                itemStore.allItems.first(where: { $0.itemName == item.itemName }) ?? GroceryItem(itemNumber: 1)
            }
            var itemPrices : [Double] = [0, 0, 0, 0]
            for curStore in itemToDisplay.stores {
                // Add prices
                if (curStore.storeName == "Hannaford") {
                    itemPrices[0] = curStore.price
                }
                else if (curStore.storeName == "Trader Joe's") {
                    itemPrices[1] = curStore.price
                }
                else if (curStore.storeName == "Shaws") {
                    itemPrices[2] = curStore.price
                }
                else {
                    itemPrices[3] = curStore.price
                }
            }
            // WILL ASSUME THAT ALL STORES ARE ACCOUNTED FOR
            prices.append(itemPrices)
        }
                    
    }
    
    func minIndexOfGiven(itemPrice: [Double], stores: [Int]) -> Int {
        var minIndex = 0
        for i in 1..<stores.count {
            if (itemPrice[stores[i]] < itemPrice[stores[minIndex]] && itemPrice[stores[i]] != 0) {
                minIndex = i
            }
        }
        return stores[minIndex]
    }
    
    func minOfGiven(itemPrice: [Double], stores: [Int]) -> Double {
        var minPrice = itemPrice[0]
        for i in stores {
            if (itemPrice[i] < minPrice && itemPrice[i] != 0) {
                minPrice = itemPrice[i]
            }
        }
        
        return minPrice
    }
    
    func splitList(itemNames: [String], itemPrices: [[Double]], stores: [Int]) -> [String : [String : Double]] {
        // Store names where array index = item price index
        let storeNames = ["Hannaford", "Trader Joes", "Shaws", "Price Chopper"]
        
        // Create an empty dictionary that will contain store names with dictionaries depicting which items to get there and their price
        var list = [String : [String : Double]]()
        
        // Add a spot for each store in the list dictionary
        for i in stores {
            list[storeNames[i]] = [String : Double]()
        }
        
        // For each item, put item in the corresponding index if that index is the least expensive
        var storeIndexToVisit : Int
        for i in 0..<itemNames.count {
            storeIndexToVisit = minIndexOfGiven(itemPrice: itemPrices[i], stores: stores)
            list[storeNames[storeIndexToVisit]]?[itemNames[i]] = itemPrices[i][storeIndexToVisit]
        }
        
        return list
    }
    
    
    func determineBestStoreCombo(itemNames: [String], itemPrices: [[Double]], numStores: Int) -> [Int] {
        // All permutations
        let perm1 = [[0], [1], [2], [3]]
        let perm2 = [[0,1], [0,2], [0,3], [1,2], [1,3], [2,3]]
        let perm3 = [[0,1,2], [0,1,3], [0,2,3], [1,2,3]]
        let perm4 = [[0,1,2,3]]
        
        // Determine correct permutation to use
        var correctPerm : [[Int]]
        if (numStores == 1) {
            correctPerm = perm1
        }
        else if (numStores == 2) {
            correctPerm = perm2
        }
        else if (numStores == 3) {
            correctPerm = perm3
        }
        else {
            correctPerm = perm4
        }
        
        // Calculate minimum cost
        var minPrices = [Double]()
        var sum = 0.0
        for p in correctPerm {
            // Determine price where minimum is in one of the permutations
            for i in itemPrices {
                sum += minOfGiven(itemPrice: i, stores: p)
            }
            minPrices.append(sum)
            sum = 0
        }
        
        // Return store indexes to visit
        var minIndex = 0
        for i in 1..<minPrices.count {
            if minPrices[i] < minPrices[minIndex] {
                minIndex = i
            }
        }
        return correctPerm[minIndex]
    }
    
    func getStoreNames(list: [String : [String : Double]]) ->[String] {
        var stores = [String]()
        for (key, _) in list {
            stores.append(key)
        }
        
        return stores
    }
    
    func getItemNames(list: [String : [String : Double]], storeName: String) -> [String] {
        var items = [String]()
        for (key, value) in list {
            if (key == storeName) {
                for (itemName, _) in value {
                    items.append(itemName)
                }
            }
        }
        
        return items
    }
    
    func getPrices(list: [String : [String : Double]], storeName: String) -> [Double] {
        var prices = [Double]()
        for (key, value) in list {
            if (key == storeName) {
                for (name, price) in value {
                    
                    prices.append(price * Double(quantities[name]!))
                }
            }
        }
        
        return prices
    }
    
//    func getQuantities(list: [String : [String : Double]], quantities: String, storeName: String) -> Int {
//        var quants = [Int]()
//        for (key, value) in list {
//            if (key == storeName) {
//                for (itemName, _) in value {
//                    // Get the quantity for that item by finding the
//                }
//            }
//        }
//    }
    
    func getTotal(items: [Double]) -> Double {
        var total = 0.0
        for item in items {
            total += item
        }
        return total
    }

    var body: some View {
       
        // CONTAINER
        GeometryReader { geo in
            VStack {
                // TITLE
                HStack {
                    Text("Shopping Plan").font(.title).padding(.leading, 25)
                    Spacer()
                }.padding(.bottom, 25)
                
                // Picker
                HStack {
                    Text("Visiting:")
                    Picker(
                        "No Selection",
                        selection: $numberOfStores) {
                            ForEach(numberOfStoreStops, id: \.self) {
                                Text("\($0)")
                            }
                        }
                    Spacer()
                }
                .padding(.leading, 30)
                
                // Display the shopping trip
                ScrollView {
                    VStack {
                        // Run the proper methods
                        var bestStores = determineBestStoreCombo(itemNames: itemNames, itemPrices: prices, numStores: intNumStores)
                        var splitUpList = splitList(itemNames: itemNames, itemPrices: prices, stores: bestStores)
                        
                        // Print list
                        ForEach(getStoreNames(list: splitUpList), id: \.self) { thisStore in
                            Spacer()
                            VStack {
                                var theseItems = getItemNames(list: splitUpList, storeName: thisStore)
                                var thesePrices = getPrices(list: splitUpList, storeName: thisStore)
                                var storeTotal = getTotal(items: thesePrices)
                                if (theseItems.count != 0) {
                                    Spacer()
                                    HStack {
                                        Text("\(thisStore)").font(.title3).bold()
                                        Spacer()
                                    }.padding(.leading, 15)
                                    ForEach(0..<theseItems.count, id: \.self) { i in
                                        HStack {
                                            Text(String(format: "\(quantities[theseItems[i]]!)x  \(theseItems[i]) - $%.2f", thesePrices[i]))
                                            Spacer()
                                        }.padding(.leading, 25)
                                    }
                                    HStack {
                                        Text(String(format: "\(thisStore) Total - $%.2f", storeTotal)).underline()
                                        Spacer()
                                    }.padding(.leading, 35)
                                }
                            }
                        }
                    }
                }
                
                
                Spacer()
            }
            .onAppear {
                populateArrays()
            }
        }
    }
}

#Preview {
    CartView().environmentObject(GroceryListWithQuantities()).environmentObject(ItemStore())
}
