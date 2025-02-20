//
//  HomeView.swift
//  Rebound Journal
//
//  Created by hyunho lee on 2023/06/10.
//

import SwiftUI

/// Main home tab for the app
struct HomeView: View {
    
    @EnvironmentObject var manager: DataManager
    @FetchRequest(sortDescriptors: []) private var results: FetchedResults<JournalEntry>
    
    // MARK: - Main rendering function
    var body: some View {
        VStack {
            TodayShootHistory()
                .onTapGesture {
                    print("TodayShootHistory")
                }
            TargetList()
        }
    }
    
    private func checkReboundList() -> [JournalEntry] {
        let isTodaySelected = Date().longFormat == manager.selectedDate.longFormat
        
        let filteredByDate = results.filter {
            $0.date?.longFormat == manager.selectedDate.longFormat && !$0.hasDeleted
        }
        
        guard isTodaySelected else {
            return filteredByDate
        }
        
        let nonReboundedNonDeleted = results.filter {
            !$0.isRebounded && !$0.hasDeleted && $0.moodLevel == 2
        }
        
        return Array(Set(nonReboundedNonDeleted + filteredByDate))
    }
    
    /// Check-in banner view
    private var CheckInBannerView: some View {
        let disableCheckIn = Date().longFormat != manager.selectedDate.longFormat
        let isPastDate = Date() > manager.selectedDate
        return ZStack {
            Color(.diaryBackground)
                .cornerRadius(16)
            HStack {
                VStack(alignment: .leading) {
                    Text(disableCheckIn ? Constants.Strings.oops : Constants.Strings.reboundShootIn)
                        .font(.system(size: 20, weight: .semibold))
                    Text(disableCheckIn ? "\(isPastDate ? Constants.Strings.past : Constants.Strings.future) \(Constants.Strings.shootInIsDisabled)" : "\(Constants.Strings.howIsYourDaySoFar)")
                }
                .foregroundColor(.light)
                
                Spacer()
                
                Button {
                    manager.fullScreenMode = .entryCreator
                } label: {
                    ZStack {
                        Color.light
                            .cornerRadius(10)
                        Text(Constants.Strings.shootIn)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.diaryBackground)
                    }
                }
                .frame(width: 88, height: 42)
                .disabled(disableCheckIn)
            }.padding()
        }
        .frame(height: 72)
        .padding([.horizontal, .bottom])
    }
}

// MARK: - Preview UI
#Preview {
    HomeView()
        .environmentObject(DataManager(preview: true))
}
