//
//  LittleLemonApp.swift
//  LittleLemon
//
//  Created by Dhai Alassaf on 22/05/2024.
//

import SwiftUI
@main
struct LittleLemonApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            Onboarding()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
