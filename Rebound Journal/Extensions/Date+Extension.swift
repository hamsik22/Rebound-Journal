//
//  Date+Extension.swift
//  Rebound Journal
//
//  Created by hyunho lee on 4/18/24.
//

import Foundation

// MARK: - Useful extensions
extension Date {
    var longFormat: String {
        string(format: "MM/dd/yyyy")
    }
    
    var headerTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MMMM d E"
        return formatter.string(from: self)
    }
    
    var year: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "y"
        return formatter.string(from: self)
    }
    
    var month: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: self)
    }
    
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension DateFormatter {
    // 한국어 로케일 및 "E" 형식(요일)으로 설정된 DateFormatter를 반환하는 static 메소드
    static func koreanWeekdayFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 로케일 설정
        formatter.dateFormat = "E" // 요일만 표시
        return formatter
    }
}
