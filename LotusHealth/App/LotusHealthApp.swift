//
//  LotusHealthApp.swift
//  LotusHealth
//
//  Created by Akshay Kalucha on 2/28/25.
//

import SwiftUI

@main
struct LotusHealthApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            
            NavigationView {
                HomeView()
                    .preferredColorScheme(.dark) // Enforce dark mode
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
