//
//  String+Extension.swift
//  Rebound Journal
//
//  Created by hyunho lee on 4/18/24.
//

import Foundation

extension String {
    func date(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
    var date: Date? {
        date(format: "MM/dd/yyyy")
    }
    
    var time: Date? {
        date(format: "h:mm a")
    }
    
    var dateComponents: DateComponents {
        guard let dateObject = time else { return DateComponents() }
        return Calendar.current.dateComponents([.hour, .minute], from: dateObject)
    }
}
