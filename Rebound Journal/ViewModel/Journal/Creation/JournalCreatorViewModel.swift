//
//  JournalCreateViewModel.swift
//  Rebound Journal
//
//  Created by 황석현 on 3/21/25.
//

import Foundation
import SwiftData

class JournalCreatorViewModel: ObservableObject {
    
    // UI State
    @Published var isSliderEditing: Bool = false
    
    // Data
    @Published var goalType: Bool? = nil // 골인 || 리바운드
    @Published var emotionValue: Double? = nil // 슬라이더 값(0~3)
    @Published var emotionText: [String]? = nil // 감정태그(EmotionText)
    @Published var reviewText: String? = nil // 슛하고 느낀 점
    @Published var nextPlanText: String? = nil // 향후 계획
    @Published var purpose: String? = nil
    @Published var mainGoal: String? = nil
    @Published var subGoal: String? = nil
    
    /// SwiftData로 저장하는 로직
    func saveJournal(context: ModelContext) {
        debugPrint("Save Journal To SwiftData")
        
        let journal = JournalData(id: UUID().uuidString,
                                  date: Date(),
                                  hasDeleted: false,
                                  isGoalIn: goalType,
                                  emotionValue: Int(emotionValue ?? 0.0),
                                  emotionText: emotionText?.first,
                                  review: reviewText,
                                  nextPlan: nextPlanText,
                                  isRebounded: false,
                                  purpose: purpose,
                                  mainGoal: mainGoal,
                                  subGoal: subGoal
        )
        context.insert(journal) // 데이터 저장
        debugPrint("""
        저장된 Journal:
        - ID: \(String(describing: journal.id))
        - Date: \(String(describing: journal.date))
        - hasDeleted: \(String(describing: journal.hasDeleted))
        - isGoalIn: \(String(describing: journal.isGoalIn))
        - Emotion Value: \(String(describing: journal.emotionValue))
        - Emotion Text: \(journal.emotionText ?? "nil")
        - Review: \(journal.review ?? "nil")
        - Next Plan: \(journal.nextPlan ?? "nil")
        - isRebounded: \(String(describing: journal.isRebounded))
        - Purpose: \(journal.purpose ?? "nil")
        - Main Goal: \(journal.mainGoal ?? "nil")
        - Sub Goal: \(journal.subGoal ?? "nil")
        """)
    }
    
    func saveSubGoal(context: ModelContext) {
        debugPrint("Save SubGoal To SwiftData")
        
        let subGoalData = SubGoalData(id: UUID().uuidString,
                                      date: Date(),
                                      goalText: subGoal)
        context.insert(subGoalData)
        debugPrint("저장된 SubGoal: \(String(describing: subGoalData.goalText))")
    }
}
