//
//  JournalCreationStep.swift
//  Rebound Journal
//
//  Created by 황석현 on 2/21/25.
//

import Foundation

enum JournalCreationStep: CaseIterable, Identifiable {
    var id: Int { hashValue }
    
    case isSuccess, // 성공(슛) 여부
         isRelatedTarget, // 관련 목표
         howFeelingNow, // 느낀 감정
         yourExperience, // 이번 경험
         nextPlan, // 다음 계획
         completeCreation
    
    var headerTitle: String {
        switch self {
        case .isSuccess:
            ""
        case .isRelatedTarget:
            ""
        case .howFeelingNow:
            ""
        case .yourExperience:
            ""
        case .nextPlan:
            ""
        case .completeCreation:
            ""
        }
    }
    
    var headerQuestion: String {
        switch self {
        case .isSuccess:
            ""
        case .isRelatedTarget:
            ""
        case .howFeelingNow:
            ""
        case .yourExperience:
            ""
        case .nextPlan:
            ""
        case .completeCreation:
            ""
        }
    }
    
    var step: Int {
        switch self {
        case .isSuccess:
            1
        case .isRelatedTarget:
            1
        case .howFeelingNow:
            2
        case .yourExperience:
            3
        case .nextPlan:
            4
        case .completeCreation:
            5
        }
    }
}
