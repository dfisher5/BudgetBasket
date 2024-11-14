//
//  GroceryListWithQuantities.swift
//  BudgetBasket
//
//  Created by Sarah Stevens on 11/13/24.
//

import SwiftUI

class GroceryListWithQuantities: ObservableObject {
    @Published var itemsWithQuantities: [itemQuantity] = []
    
    let loadFromFile = true
    let bundleFilename = "groceryList-init.json"
    let groceryListURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("groceryList.json")
    }()
    
    func load<T: Decodable>(_ url: URL) -> T {
        let data: Data
        
        do {
            data = try Data(contentsOf: url)
        } catch {
            fatalError("Couldn't load \(url.path) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            print("parse \(url.path)")
            fatalError("Couldn't parse \(url.path) as \(T.self):\n\(error)")
        }
    }
    
    struct itemQuantity: Codable, Identifiable, Equatable, CustomStringConvertible {
        var id = UUID()
        var itemName: String
        var quantity: Int
        
        mutating func increaseQuantity(){
            quantity += 1
        }
        
        mutating func decreaseQuantity(){
            if quantity > 0 {
                quantity -= 1
            }
        }
        
        static func == (one: itemQuantity, two: itemQuantity) -> Bool {
            one.itemName == two.itemName
        }
        
        var description: String {
            return "\(quantity) \(itemName)"
        }
        
    }
    
    init(){
        if loadFromFile {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: groceryListURL.path){
                print("load from \(groceryListURL.path)")
                self.itemsWithQuantities = load(groceryListURL)
            }
        } else {
            if let url = Bundle.main.url(forResource: bundleFilename, withExtension: nil){
                print("load from \(url.path)")
                self.itemsWithQuantities = load(url)
            } else {
                fatalError("can't find file to load")
            }
        }
    }
}
