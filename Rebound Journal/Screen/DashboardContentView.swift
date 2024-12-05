//
//  DashboardContentView.swift
//  Rebound Journal
//
//  Created by hyunho lee on 2023/06/10.
//

import SwiftUI

struct DashboardContentView: View {
    
    @EnvironmentObject var manager: DataManager
    @FetchRequest(sortDescriptors: []) private var results: FetchedResults<JournalEntry>
    @State private var isSettingsSheetPresented = false
    
    var body: some View {
        ZStack {
            // MARK: 00. 색상을 정의하는 방법에 대하여
            Color.diaryBackground
                .ignoresSafeArea()
            MainContainer
        }
        // MARK: 10. 화면이동 중 전체화면을 덮는 방법
        .fullScreenCover(item: $manager.fullScreenMode) { type in
            switch type {
            case .entryCreator:
                JournalEntryCreatorView()
                    .environmentObject(manager)
            case .readJournalView:
                JournalDetailView()
                    .environmentObject(manager)
            case .reboundCreator:
                JournalEntryCreatorView(isRebounded: true)
                    .environmentObject(manager)
            case .passcodeView:
                PasscodeView().environmentObject(manager)
            case .setupPasscodeView:
                PasscodeView(setupMode: true).environmentObject(manager)
            }
        }
        /// Show the passcode view if the passcode was setup
        .onAppear() {
            //Interstitial.shared.loadInterstitial()
            if manager.savedPasscode.count == 4 && !manager.didEnterCorrectPasscode {
                manager.fullScreenMode = .passcodeView
            }
        }
        .sheet(isPresented: $isSettingsSheetPresented) {
            SettingsView() // 모달로 표시될 View
        }
    }
    
    // MARK: 01. 뷰를 따로 떼어놓는 것에 대한 방법
    private var MainContainer: some View {
        VStack(spacing: 15) {
            HeaderTitle
            HeaderCalendarView
            HomeView()
                .environmentObject(manager)
        }
    }
    
    private var HeaderTitle: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                // MARK: 02. date format을 사용하는 것에 대하여
                Text(manager.selectedDate.headerTitle)
                // MARK: 03. 고정 문구를 관리하는 것에 대하여
                HStack {
                    Text(Constants.Strings.mainTitle)
                        .font(.largeTitle)
                        .bold()
#warning("설정 페이지, 차트")
                    Spacer()
//                    Button {
//                        
//                    } label: {
//                        Image(systemName: "chart.bar.xaxis")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 25)
//                    }
                    
                    Button {
                        isSettingsSheetPresented.toggle()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                    }

                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .foregroundColor(.lightColor)
    }
    
    private var HeaderCalendarView: some View {
        // MARK: 04. ScrollViewReader를 활용한 스크롤뷰의 위치 조정
        ScrollViewReader { proxy in
            // MARK: 05. 제공하는 기능들을 잘 알고 쓰기
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    Spacer(minLength: 0)
                    ForEach(manager.calendarDays.indices, id: \.self) { index in
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
    
    // MARK: 06. 뷰를 따로 떼어놓는 것에 대한 방법2 -> 변수를 받기
    private func CalendarItem(atIndex index: Int) -> some View {
        let entries = results.filter({ $0.date?.longFormat == manager.calendarDays[index].longFormat })
        let date = manager.calendarDays[index]
        // MARK: 07. 날짜를 비교하는 간단한 방법
        let isTodayItem = date.longFormat == Date().longFormat
        let isSelectedItem = manager.selectedDate.longFormat == date.longFormat
        return VStack(spacing: 2) {
            ZStack {
                
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 44, height: 39, alignment: .center)
                    .foregroundColor(isTodayItem ? .diaryBackground : .diarySecondaryBackground)
                    // MARK: 08. 3항 연산자로 if문을 줄이는 방법
                    //.opacity(isTodayItem ? 1 : (isSelectedItem ? 0.65 : 0.1))
                if entries.count > 0 {
                    Image("Ball")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 39, alignment: .center)
                        .opacity(0.35)
                }
                Text(date.string(format: "d"))
                    .font(.system(size: 22, weight: .semibold))
                    //.foregroundStyle(isTodayItem || isSelectedItem ? .light : .diaryPrimary) 어떻게 할까 고민 중
                    .foregroundStyle(entries.count > 0 ? .light : .diaryPrimary)
            }
            // MARK: 09. 요일을 한국어로 표기하는 방법
            Text(DateFormatter.koreanWeekdayFormatter()
                .string(from: date))
                .font(.system(size: 12))
                .foregroundColor(.text)
        }
        .padding(5)
        .background(Color.diarySecondary.cornerRadius(10))
    }
}

