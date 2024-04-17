//
//  View+Extension.swift
//  Rebound Journal
//
//  Created by hyunho lee on 4/18/24.
//

import SwiftUI

/// Hide keyboard from any view
extension View {
    func hideKeyboard() {
        DispatchQueue.main.async {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
