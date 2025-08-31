//
//  HomeViewModel.swift
//  Rebound Journal
//
//  Created by 황석현 on 8/29/25.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    
    func getGoalInfo(targets: [SubGoalData], journals: [JournalData]) -> [GoalInfo] {
        
        return generateTargetInfo(targets: targets, journals: journals)
    }
    
    func getReboundJournalInfo(journals: [JournalData]) -> [JournalData] {
        var result: [JournalData] = []
        for journal in journals {
            if let goalType = journal.isGoalIn, goalType == false {
                result.append(journal)
            }
        }
        return result
    }
    
    private func generateTargetInfo(targets: [SubGoalData], journals: [JournalData]) -> [GoalInfo] {
        
        var result: [GoalInfo] = []
        
        for target in targets {
            let count = journals.filter { $0.subGoal == target.goalText }.count
            if let goalText = target.goalText {
                let info = GoalInfo(title: goalText, count: count)
                result.append(info)
            }
        }
        
        return result
    }
}
