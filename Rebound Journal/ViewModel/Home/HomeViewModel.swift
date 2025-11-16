//
//  HomeViewModel.swift
//  Rebound Journal
//
//  Created by 황석현 on 8/29/25.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published var selectedRebound: JournalData? = nil
    
    func fetchGoalInfo(goals: [SubGoalData], journals: [JournalData]) -> [GoalInfo] {
        return generateTargetInfo(goals: goals, journals: journals)
    }
    
    func fetchReboundedJournalInfo(journals: [JournalData]) -> [JournalData] {
        return generateReboundedJournalInfo(journals: journals)
    }
    
    private func generateReboundedJournalInfo(journals: [JournalData]) -> [JournalData] {
        var result: [JournalData] = []
        for journal in journals {
            if let goalType = journal.isGoalIn, goalType == false {
                result.append(journal)
            }
        }
        return result
    }
    
    private func generateTargetInfo(goals: [SubGoalData], journals: [JournalData]) -> [GoalInfo] {
        
        var result: [GoalInfo] = []
        
        for goal in goals {
            let count = journals.filter { $0.subGoal == goal.goalText }.count
            if let goalText = goal.goalText {
                let info = GoalInfo(title: goalText, count: count)
                result.append(info)
            }
        }
        
        return result
    }
}
