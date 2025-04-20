//
//  JournalMetaData.swift
//  Rebound Journal
//
//  Created by 황석현 on 4/20/25.
//

import Foundation

struct JournalMetaData: JournalDisplayable, Identifiable {
    var id = UUID()
    
    let entry: JournalModel
    
    var date: Date {
        return entry.date
    }
    
    var isGoalIn: Bool {
        return entry.isGoalIn
    }
    
    var emotionText: String {
        return entry.emotionText
    }
    
    var review: String {
        return entry.review
    }
    
    var nextPlan: String {
        return entry.nextPlan
    }
}
