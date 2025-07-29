//
//  Alert+Extension.swift
//  Rebound Journal
//
//  Created by 정도연 on 7/9/25.
//

import SwiftUI

extension Alert {
  static func exitAlert(action: @escaping () -> Void) -> Alert {
    return Alert(
      title: Text(Constants.Strings.exitFlow),
      message: Text(Constants.Strings.exitDescription),
      primaryButton: .default(Text(Constants.Strings.exitText), action: action),
      secondaryButton: .cancel(Text(Constants.Strings.continueText))
    )
  }
}
