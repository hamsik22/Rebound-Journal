//
//  JournalCreateViewModel.swift
//  Rebound Journal
//
//  Created by 황석현 on 3/21/25.
//

import Foundation
import SwiftData

enum ReboundProcessStep: CaseIterable {
    case shoot, // 슛 타입
         emotion, // 현재 감정
         review // 느낀점 & 향후계획
}
class JournalCreatorViewModel: ObservableObject {
    
    // UI State
    @Published var currentStep: ReboundProcessStep = .shoot
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
    
    /// 코어 데이터로 저장하는 로직
    func saveShooting(manager: DataManager) {
        debugPrint("기록 저장하기(No Image)")
        guard let text = reviewText,
              let moodLevel = goalType,
              let moodText = emotionText?.first,
              let reasons = reviewText,
              let reboundText = nextPlanText
        else { return }
        manager.saveEntry_V2(text: text,
                          moodLevel: moodLevel ? 1 : 2,
                          moodText: moodText,
                          reboundText: reboundText,
                          reasons: reasons)
    }
    
    /// SwiftData로 저장하는 로직
    func saveJournalToSwiftData(context: ModelContext) {
        print("Save Journal To SwiftData")
        
        let journal = JournalData(id: UUID().uuidString,
                                  date: Date(),
                                  isGoalIn: goalType,
                                  emotionValue: Int(emotionValue ?? 0.0),
                                  emotionText: emotionText?.first,
                                  review: reviewText,
                                  nextPlan: nextPlanText,
                                  purpose: purpose,
                                  mainGoal: mainGoal,
                                  subGoal: subGoal)
        print("Journal ReviewText: \(String(describing: reviewText))")
        context.insert(journal) // 데이터 저장
    }
}
