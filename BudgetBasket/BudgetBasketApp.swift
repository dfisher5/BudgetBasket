//
//  BudgetBasketApp.swift
//  BudgetBasket
//
//  Created by Delaney Fisher on 9/24/24.
//

import SwiftUI

@main
struct BudgetBasketApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
