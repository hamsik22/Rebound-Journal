//
//  UIAlertAction+Extension.swift
//  Rebound Journal
//
//  Created by hyunho lee on 4/18/24.
//

import UIKit

extension UIAlertAction {
    static var OK: UIAlertAction {
        UIAlertAction(title: "OK", style: .cancel, handler: nil)
    }
    
    static var Cancel: UIAlertAction {
        UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    }
}
