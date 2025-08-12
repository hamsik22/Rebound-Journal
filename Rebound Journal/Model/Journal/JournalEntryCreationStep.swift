//
//  JournalEntryCreatorView.swift
//  Rebound Journal
//
//  Created by hyunho lee on 2023/06/10.
//

import SwiftUI

enum EntryCreationStep: CaseIterable, Identifiable {
  case mood, today, shoot  //, images
  var id: Int { hashValue }

  var question: String {
    switch self {
    case .mood: return Constants.Strings.feelToday
    case .today: return Constants.Strings.todayShoot
    case .shoot: return Constants.Strings.howToRebound
    }
  }

  var reboundQuestion: String {
    switch self {
    case .mood: return Constants.Strings.reboundFeelToday
    case .today: return Constants.Strings.reboundTodayShoot
    case .shoot: return Constants.Strings.reboundHowToRebound
    }
  }

  var process: Int {
    switch self {
    case .mood: return 1
    case .today: return 2
    case .shoot: return 3
    }
  }
}
