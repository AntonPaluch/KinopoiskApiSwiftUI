//
//  Extension.swift
//  KinopoiskApiSwiftUI
//
//  Created by Павлов Дмитрий on 21.09.2024.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
