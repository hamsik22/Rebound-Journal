//
//  Protocols.swift
//  Rebound Journal
//
//  Created by 황석현 on 4/16/25.
//

import Foundation

/// 조회된 데이터의 현황을 요약
protocol JournalSummarizable {
    var streak: Int { get }
    var total: Int { get }
    var goals: Int { get }
    var rebounds: Int { get }
}

/// 화면에 표시될 저널의 기록들
protocol JournalDisplayable {
    var date: Date { get }
    var isGoalIn: Bool { get }
    var emotionText: String { get }
    var review: String { get }
    var nextPlan: String { get }
}

/// 차트화면에 표시될 데이터
protocol ChartDisplayable {
    var id: UUID { get }
    var date: Date { get }
    var isGoalIn: Bool { get }
}
