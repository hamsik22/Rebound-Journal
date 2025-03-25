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
    
    // MARK: State
    @Published var currentStep: ReboundProcessStep = .shoot
    @Published var isSliderEditing: Bool = false
    
    // MARK: Data
    @Published var goalType: Bool? = nil
    @Published var emotionValue: Double? = nil
    @Published var emotionText: [String]? = nil
    @Published var reviewText: String? = nil
    @Published var nextPlanText: String? = nil
    
    func saveShooting() {
        debugPrint("saveShooting")
    }
}
