//
//  viewModel.swift
//  Rebound Journal
//
//  Created by 황석현 on 4/16/25.
//

import Foundation
import CoreData
import SwiftUI

final class ChartViewModel: ObservableObject {
    @Published var journals: [JournalModel]
    @Published var journalSummary: JournalSummary
    @Published var journalData: [JournalMetaData]
    @Published var groupedJournalData: [(key: String, value: [JournalMetaData])] = []
    @Published var journalChart: [JournalChart] = []

    init() {
        let mockJournals = JournalModel.mockData()
        self.journals = mockJournals
        self.journalSummary = JournalSummary(entries: mockJournals)
        self.journalData = mockJournals.map { JournalMetaData(entry: $0) }
        self.makeChartItems(from: mockJournals)
        self.makeGroupedJournalData()
    }
    
    func makeChartItems(from journals: [JournalModel]) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // 7일치 날짜 생성: [0~6]일 전
        let last7Days = (0...6).compactMap {
            calendar.date(byAdding: .day, value: -$0, to: today)
        }.reversed() // 과거 -> 오늘 순

        // 날짜 기준으로 초기화된 결과
        var result: [JournalChart] = []

        for date in last7Days {
            let dayJournals = journals.filter {
                !$0.hasDeleted && calendar.isDate($0.date, inSameDayAs: date)
            }

            let goalInCount = dayJournals.filter { $0.isGoalIn }.count
            let reboundCount = dayJournals.filter { !$0.isGoalIn }.count

            if goalInCount > 0 {
                result.append(JournalChart(date: date, isGoalIn: true, count: goalInCount))
            } else {
                result.append(JournalChart(date: date, isGoalIn: true, count: 0))
            }

            if reboundCount > 0 {
                result.append(JournalChart(date: date, isGoalIn: false, count: reboundCount))
            } else {
                result.append(JournalChart(date: date, isGoalIn: false, count: 0))
            }
        }

        self.journalChart = result
    }
    
    func makeGroupedJournalData() {
        let grouped = Dictionary(grouping: journalData) { $0.date.dayLabel }
        groupedJournalData = grouped.sorted { $0.key < $1.key }
    }
}
