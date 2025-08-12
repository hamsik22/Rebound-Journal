//
//  JournalChart.swift
//  Rebound Journal
//
//  Created by 황석현 on 4/20/25.
//

import Foundation

struct JournalChart: ChartDisplayable, Identifiable {
    let id = UUID()
    
    /// 해당 데이터의 날짜 (하루 단위)
    let date: Date
    /// 골인 여부 (골인/리바운드)
    let isGoalIn: Bool
    /// 해당 날짜의 골인 또는 리바운드 횟수
    let count: Int
}

/// 차트 데이터를 그룹핑하기 위한 구조체
struct ChartGroupKey: Hashable {
    let dateOnly: Date
    let isGoalIn: Bool
}
