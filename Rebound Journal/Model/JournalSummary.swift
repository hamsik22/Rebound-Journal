//
//  JournalSummary.swift
//  Rebound Journal
//
//  Created by 황석현 on 4/20/25.
//

import Foundation

/// 조회된 Journal의 현황(hasDeleted 제외)
struct JournalSummary: JournalSummarizable {
    let entries: [JournalModel]
    
    /// 연속 일수
    var streak: Int { return entries.calculateStreak() }
    /// 전체 갯수
    var total: Int { return entries.filter{ !$0.hasDeleted }.count }
    /// 골인 갯수
    var goals: Int { return entries.filter{ !$0.hasDeleted && $0.isGoalIn }.count }
    /// 리바운드 갯수
    var rebounds: Int { return entries.filter{ !$0.hasDeleted && !$0.isGoalIn }.count }
}
