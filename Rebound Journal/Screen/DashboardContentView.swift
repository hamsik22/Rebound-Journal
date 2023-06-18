//
//  DashboardContentView.swift
//  Rebound Journal
//
//  Created by hyunho lee on 2023/06/10.
//

import SwiftUI

// MARK: - Custom tab bar items
enum CustomTabBarItem: String, Identifiable, CaseIterable {
    case home = "house.fill", stats = "chart.bar.xaxis"
    case quotes = "quote.closing", settings = "gearshape.fill"
    var id: Int { hashValue }
    
    /// Custom header title for each tab
    var headerTitle: String {
        switch self {
        case .home: return "Rebound Journal"
        case .stats: return "Fun Statistics"
        case .quotes: return "Get Inspired"
        case .settings: return "Settings"
        }
    }
}

/// Main dashboard for the app
struct DashboardContentView: View {
    
    @EnvironmentObject var manager: DataManager
    @State private var selectedTab: CustomTabBarItem = .home
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            CustomTabBarContainer
            //CustomTabBarView
            //PreviewImageFullScreen
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
            case .premium:
                Text("1")
                //PremiumView
            case .passcodeView:
                Text("1")
                //PasscodeView().environmentObject(manager)
            case .setupPasscodeView:
                Text("1")
                //PasscodeView(setupMode: true).environmentObject(manager)
            }
        }
        /// Show the passcode view if the passcode was setup
        .onAppear() {
//            Interstitial.shared.loadInterstitial()
            if manager.savedPasscode.count == 4 && !manager.didEnterCorrectPasscode {
                manager.fullScreenMode = .passcodeView
            }
        }
    }
    
    /// Custom tab bar container
    private var CustomTabBarContainer: some View {
        ZStack {
            VStack(spacing: 15) {
                HeaderTitle
                switch selectedTab {
                case .home:
                    HeaderCalendarView
                    HomeTabView()
                        .environmentObject(manager)
                case .stats:
                    Text("test")
                    //StatsTabView().environmentObject(manager)
                case .quotes:
                    Text("test")
                    //QuotesTabView().environmentObject(manager)
                case .settings:
                    Text("test")
                    //SettingsTabView().environmentObject(manager)
                }
            }
        }.animation(nil)
    }
    
    /// Header title
    private var HeaderTitle: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(manager.selectedDate.headerTitle)
//                Text("01/10")
                Text(selectedTab.headerTitle).font(.largeTitle).bold()
            }
            Spacer()
        }.padding(.horizontal).foregroundColor(Color("LightColor"))
    }
    
    /// Header calendar view
    private var HeaderCalendarView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                HStack(spacing: 15) {
                    Spacer(minLength: 0)
                    ForEach(0..<manager.calendarDays.count, id: \.self) { index in
                        CalendarItem(atIndex: index).id(index).onTapGesture {
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
    
    /// Bottom Custom tab bar view
    private var CustomTabBarView: some View {
        ZStack {
            VStack {
                Spacer()
                LinearGradient(gradient: Gradient(colors: [Color("ListColor").opacity(0), Color("ListColor").opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea().frame(height: 150).allowsHitTesting(false)
            }
            VStack {
                Spacer()
                ZStack {
                    Color("TabBarColor").cornerRadius(40)
                        .shadow(color: Color.black.opacity(0.2), radius: 10)
                    HStack(spacing: 35) {
                        ForEach(CustomTabBarItem.allCases) { tabItem in
                            TabBarItem(type: tabItem)
                        }
                    }
                }.padding(.horizontal, 30).frame(height: 65)
            }
        }
    }
    
    private func TabBarItem(type: CustomTabBarItem) -> some View {
        Button {
            withAnimation { selectedTab = type }
        } label: {
            VStack(spacing: 0) {
                Spacer()
                Image(systemName: type.rawValue).font(.system(size: 25, weight: .light))
                    .foregroundColor(Color("ListColor")).offset(y: -2)
                    .opacity(selectedTab == type ? 1 : 0.4)
                Spacer()
                Circle().foregroundColor(.white)
                    .frame(width: 20, height: 20)
                    .opacity(selectedTab == type ? 1 : 0)
            }.offset(y: 12).mask(Rectangle())
        }
    }
    
    /// Preview image full screen
    private var PreviewImageFullScreen: some View {
        ZStack {
            if let entryImage = manager.selectedEntryImage {
                PhotoDetailView(image: entryImage).ignoresSafeArea()
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            manager.selectedEntryImage = nil
                        } label: {
                            ZStack {
                                Color.clear.frame(width: 25, height: 25, alignment: .center)
                                Image(systemName: "xmark").resizable().aspectRatio(contentMode: .fit)
                                    .frame(width: 18, height: 18, alignment: .center)
                            }
                        }.foregroundColor(Color("LightColor"))
                    }
                    Spacer()
                }.padding(.horizontal)
            }
        }.animation(.easeInOut)
    }
    
    /// Premium view
    private var PremiumView: some View {
//        PremiumContentView(title: "Premium Version", subtitle: "Unlock All Features", features: ["Enable App Passcode", "Add Photos to journal", "Remove ads"], productIds: [AppConfig.premiumVersion], completion: { _, status, _ in
//            DispatchQueue.main.async {
//                if status == .success || status == .error {
//                    manager.isPremiumUser = true
//                }
//            }
//        }).environmentObject(manager)
        Text("")
    }
}

