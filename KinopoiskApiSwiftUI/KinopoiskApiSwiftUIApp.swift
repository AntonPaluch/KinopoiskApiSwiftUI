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
    @StateObject private var router = Router()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(router)
                .environmentObject(AlertManager.shared)
        }
    }
}
