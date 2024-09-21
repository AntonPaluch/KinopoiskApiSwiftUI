//
//  AlertManager.swift
//  KinopoiskApiSwiftUI
//
//  Created by Павлов Дмитрий on 21.09.2024.
//

import Combine
import Foundation

@MainActor
class AlertManager: ObservableObject {
    static let shared = AlertManager()
    
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    func showAlert(title: String, message: String) {
        self.alertTitle = title
        self.alertMessage = message
        self.showAlert = true
    }
}
