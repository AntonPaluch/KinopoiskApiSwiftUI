//
//  KinopoiskApiSwiftUIApp.swift
//  KinopoiskApiSwiftUI
//
//  Created by Павлов Дмитрий on 19.09.2024.
//

import SwiftUI

@main
struct KinopoiskApiSwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
