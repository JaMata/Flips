//
//  FlipsApp.swift
//  Flips
//
//  Created by Jordan Foster on 3/17/21.
//

import SwiftUI

@main
struct FlipsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LoginScreen()
                .preferredColorScheme(.dark)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(UserAuth())
        }
    }
}
