//
//  TodoApp.swift
//  Todo
//
//  Created by Dayal, Utkarsh on 26/05/21.
//

import SwiftUI

@main
struct TodoApp: App {
    let persistenceController = PersistenceController.shared
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
