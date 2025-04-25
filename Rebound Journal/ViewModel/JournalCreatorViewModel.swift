//
//  JournalCreateViewModel.swift
//  Rebound Journal
//
//  Created by 황석현 on 3/21/25.
//

import Foundation
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
}
