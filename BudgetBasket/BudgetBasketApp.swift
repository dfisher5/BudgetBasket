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
    init() {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color("Background"))
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.theme.accent)
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color("TabColor"))
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView() {
                StartScreenView()
            }
        }
    }
}

