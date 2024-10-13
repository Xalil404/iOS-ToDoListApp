//
//  ToDoListAppApp.swift
//  ToDoListApp
//
//  Created by TEST on 12.10.2024.
//

import SwiftUI

@main
struct ToDoListAppApp: App {
    let persistenceController = PersistenceController.shared
    
    @State private var showOnboarding = true // Always show onboarding on app launch

    var body: some Scene {
        WindowGroup {
            if showOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
            } else {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}



