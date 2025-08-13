//
//  JournalMetaData.swift
//  Rebound Journal
//
//  Created by 황석현 on 4/20/25.
//

import Foundation

struct JournalMetaData: JournalDisplayable, Identifiable {
    var id = UUID()
    let entry: JournalData
    
    /// 기록 날짜
    var date: Date { return entry.dateUnwrapped }
    /// 골인 여부 (골인/리바운드)
    var isGoalIn: Bool { return entry.isGoalInUnwrapped }
    /// 감정 태그
    var emotionText: String { return entry.emotionTextUnwrapped }
    /// 느낀 점
    var review: String { return entry.reviewUnwrapped }
    /// 향후 계획
    var nextPlan: String { return entry.nextPlanUnwrapped }
}
