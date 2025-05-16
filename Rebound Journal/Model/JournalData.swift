//
//  JournalData.swift
//  Rebound Journal
//
//  Created by 황석현 on 5/11/25.
//

import Foundation
import SwiftData

@Model
final class JournalData {

    var id: String // 식별값
    var date: Date // 생성 일자
    var hasDeleted: Bool // 삭제 여부
    var isGoalIn: Bool? // 골인여부
    var emotionValue: Int? // 감정 수치
    var emotionText: String? // 감정 태그
    var review: String? // 느낀 점
    var nextPlan: String? // 향후 계획
    var isRebounded: Bool? // 리바운드 여부
    
    var purpose: String? // 목적
    var mainGoal: String? // 큰 목표
    var subGoal: String? // 작은 목표
    
    init(id: String, date: Date,
         hasDeleted: Bool = false,
         isGoalIn: Bool? = nil,
         emotionValue: Int? = nil,
         emotionText: String? = nil,
         review: String? = nil,
         nextPlan: String? = nil,
         isRebounded: Bool? = nil,
         purpose: String? = nil,
         mainGoal: String? = nil,
         subGoal: String? = nil) {
        self.id = id
        self.date = date
        self.hasDeleted = hasDeleted
        self.isGoalIn = isGoalIn
        self.emotionValue = emotionValue
        self.emotionText = emotionText
        self.review = review
        self.nextPlan = nextPlan
        self.isRebounded = isRebounded
        self.purpose = purpose
        self.mainGoal = mainGoal
        self.subGoal = subGoal
    }
}
