//
//  HistoryView.swift
//  Rebound Journal
//
//  Created by hyunho lee on 12/7/24.
//

import SwiftUI
import CoreData
import Charts

struct HistoryView: View {
    @EnvironmentObject var manager: DataManager
    
    @FetchRequest(
        entity: JournalEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \JournalEntry.date, ascending: false)]
    )
    var entries: FetchedResults<JournalEntry>
    
    var groupedEntries: [String: [JournalEntry]] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        
        return Dictionary(grouping: entries) { entry in
            guard let date = entry.date else { return "" }
            return formatter.string(from: date)
        }
    }
    
    var body: some View {
        NavigationView {
            
                ScrollView {
                    ZStack {
                        
                        RoundedCorner(radius: 30, corners: [.topLeft, .topRight])
                            .foregroundStyle(.list)
                            .ignoresSafeArea()
                    VStack(spacing: 16) {
                        BarChartView(entries: groupedEntries)
                        LazyVStack(spacing: 16) {
                            ForEach(groupedEntries.keys.sorted(by: >), id: \String.self) { key in
                                if let dayEntries = groupedEntries[key] {
                                    Section(header: Text(key).frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.headline)
                                        .padding(.vertical, 8)) {
                                            ForEach(dayEntries, id: \JournalEntry.id) { entry in
                                                JournalEntryItemView(model: entry)
                                                    .onTapGesture {
                                                        manager.fullScreenMode = .readJournalView
                                                        manager.seledtedEntry = entry
                                                    }
                                            }
                                        }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .background(.diaryBackground)
            .navigationTitle(Constants.Strings.history)
        }
    }
}

struct BarChartView: View {
    let entries: [String: [JournalEntry]]
    
    var body: some View {
        let chartData = createChartData().reversed()
        
        Chart {
            ForEach(chartData, id: \.0) { date, values in // Using the first element (date) as the id
                ForEach(values, id: \.0) { label, value in // Using the first element (label) as the id
                    BarMark(
                        x: .value("Date", date),
                        y: .value("Count", value)
                    )
                    .foregroundStyle(by: .value("Label", label))
                }
            }
        }
        .chartXAxis {
            AxisMarks(preset: .aligned) { value in
                AxisValueLabel() // Display X-axis labels as dates
            }
        }
        .chartYAxis {
            AxisMarks(preset: .aligned) { value in
                AxisValueLabel() // Display Y-axis labels as counts
            }
        }
        .chartForegroundStyleScale([
            "골인 ✅": Color.orange, // Set color for success label
            "리바운드 ❌": Color.yellow // Set color for failure label
        ])
        .frame(height: 300)
        .padding(.horizontal, 16)
    }
    
    private func createChartData() -> [(String, [(String, Double)])] {
        // Generate chart data based on moodLevel counts
        return entries.keys.sorted(by: >).map { dateKey in
            let dayEntries = entries[dateKey] ?? []
            let successCount = dayEntries.filter { $0.moodLevel == 1 }.count
            let failureCount = dayEntries.filter { $0.moodLevel == 2 }.count
            
            return (dateKey, [
                ("골인 ✅", Double(successCount)),
                ("리바운드 ❌", Double(failureCount))
            ])
        }
    }
}


#Preview {
    HistoryView()
}
