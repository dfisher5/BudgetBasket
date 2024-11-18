//
//  BudgetBasketApp.swift
//  BudgetBasket
//
//  Created by Delaney Fisher on 9/24/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
     FirebaseApp.configure()

    return true
  }
}

@main
struct BudgetBasketApp: App {
//    let persistenceController = PersistenceController.shared
    
    init() {
        // Use Firebase library to configure APIs
         FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView() {
                StartScreenView()
            }
        }
    }
}

