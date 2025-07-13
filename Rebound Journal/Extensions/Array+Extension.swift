//
//  Array+Ext.swift
//  Rebound Journal
//
//  Created by 황석현 on 4/20/25.
//

import Foundation

extension Array where Element == JournalModel {
    
    /// 연속 기록일수를 계산하는 함수
    func calculateStreak() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // 날짜 기준으로 정렬된 데이터
        let sorted = self
            .filter { !$0.hasDeleted }
            .sorted { $0.date > $1.date }

        var streak = 0
        var expectedDate = today

        for journal in sorted {
            let journalDate = calendar.startOfDay(for: journal.date)

            if journalDate == expectedDate {
                streak += 1
                expectedDate = calendar.date(byAdding: .day, value: -1, to: expectedDate)!
            } else if journalDate < expectedDate {
                // 기록이 연속되지 않았으므로 종료
                break
            }
        }
        return streak
    }
}
