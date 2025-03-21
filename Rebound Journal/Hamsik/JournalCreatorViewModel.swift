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
    @Published var currentStep: ReboundProcessStep = .shoot
    @Published var goalType: Bool? = nil
}
