//
//  DashboardContentView.swift
//  Rebound Journal
//
//  Created by hyunho lee on 2023/06/10.
//

import SwiftUI

/// Main dashboard for the app
struct DashboardContentView: View {
    
    @EnvironmentObject var manager: DataManager
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            MainContainer
        }
        // Full modal screen flow
        .fullScreenCover(item: $manager.fullScreenMode) { type in
            switch type {
            case .entryCreator:
                JournalEntryCreatorView()
                    .environmentObject(manager)
            case .readJournalView:
                JournalDetailView()
                    .environmentObject(manager)
            }
        }
    }
    
    /// Main container
    private var MainContainer: some View {
        VStack(spacing: 15) {
            HeaderTitle
            HeaderCalendarView
            HomeView()
                .environmentObject(manager)
        }
    }
    
    /// Header title
    private var HeaderTitle: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(manager.selectedDate.headerTitle)
                Text(Constants.Strings.mainTitle)
                    .font(.largeTitle)
                    .bold()
            }
            Spacer()
        }
        .padding(.horizontal)
        .foregroundColor(Color("LightColor"))
    }
    
    /// Header calendar view
    private var HeaderCalendarView: some View {
        // ScrollViewReader를 활용한 스크롤뷰의 위치 조정
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    Spacer(minLength: 0)
                    ForEach(0..<manager.calendarDays.count, id: \.self) { index in
                        CalendarItem(atIndex: index)
                            .id(index)
                            .onTapGesture {
                                manager.selectedDate = manager.calendarDays[index]
                            }
                    }
                    Spacer(minLength: 0)
                }.onAppear {
                    proxy.scrollTo(manager.calendarDays.count-1)
                }
            }
        }
    }
    
    /// Header calendar item view
    private func CalendarItem(atIndex index: Int) -> some View {
        let date = manager.calendarDays[index]
        let isTodayItem = date.longFormat == Date().longFormat
        let isSelectedItem = manager.selectedDate.longFormat == date.longFormat
        return VStack(spacing: 2) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 44, height: 39, alignment: .center)
                    .foregroundColor(Color("BackgroundColor"))
                    .opacity(isTodayItem ? 1 : (isSelectedItem ? 0.65 : 0.1))
                Text(date.string(format: "d"))
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(isTodayItem || isSelectedItem ? Color("LightColor") : Color("Primary"))
            }
            Text(date.string(format: "E"))
                .font(.system(size: 12))
                .foregroundColor(Color("Primary"))
        }
        .padding(5)
        .background(Color("LightColor")
            .cornerRadius(10))
    }
}

