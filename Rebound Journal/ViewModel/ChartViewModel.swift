//
//  viewModel.swift
//  Rebound Journal
//
//  Created by 황석현 on 4/16/25.
//

import Foundation
import CoreData
import SwiftUI

final class ChartViewModel: ObservableObject {
    @Published var journals: [JournalModel]
    @Published var journalSummary: JournalSummary
    @Published var journalData: [JournalMetaData]

    init() {
        let mockJournals = JournalModel.mockData()
        self.journals = mockJournals
        self.journalSummary = JournalSummary(entries: mockJournals)
        self.journalData = mockJournals.map { JournalMetaData(entry: $0) }
    }
}
