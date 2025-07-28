//
//  DashboardContentView.swift
//  Rebound Journal
//
//  Created by hyunho lee on 2023/06/10.
//

import SwiftUI
import SwiftData

struct DashboardContentView: View {
    
    @EnvironmentObject var manager: DataManager
    @Environment(\.modelContext)private var modelContext
    @Environment(\.managedObjectContext)private var context
    @ObservedObject var journalCreatorViewModel = JournalCreatorViewModel()
    @ObservedObject var chartViewModel = ChartViewModel()
    @FetchRequest(sortDescriptors: []) private var results: FetchedResults<JournalEntry>
    @Query private var journals: [JournalData]
    @Query private var subGoals: [SubGoalData]
    @State private var isSettingsSheetPresented = false
    @State private var isHistorySheetPresented = false
    @State private var journalCreatorStep: ReboundProcessStep = .createSubGoal
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            VStack {
                topTrailingButton
                goalStatusText
                subGoalList
            }
            bottomButton
        }
        .padding()
        // MARK: 10. 화면이동 중 전체화면을 덮는 방법
        .fullScreenCover(item: $manager.fullScreenMode) { type in
            switch type {
            case .entryCreator:
                JounrnalCreator(viewModel: journalCreatorViewModel, currentStep: $journalCreatorStep)
                    .environmentObject(manager)
            case .readJournalView:
                JournalDetailView()
                    .environmentObject(manager)
            case .reboundCreator:
                JournalEntryCreatorView(isRebounded: true)
                    .environmentObject(manager)
            case .passcodeView:
                PasscodeView()
                    .environmentObject(manager)
            case .setupPasscodeView:
                PasscodeView(setupMode: true)
                    .environmentObject(manager)
            case .chartView:
                ChartView(viewModel: chartViewModel)
                    .environmentObject(manager)
            }
        }
        /// Show the passcode view if the passcode was setup
        .onAppear() {
            //Interstitial.shared.loadInterstitial()
            if manager.savedPasscode.count == 4 && !manager.didEnterCorrectPasscode {
                manager.fullScreenMode = .passcodeView
            }
            // 중복되지 않는 CoreData를 SwiftData로 옮기는 함수
            manager.convertDupicateDataToSwiftData(nsContext: context, modelContext: modelContext)
            // 작은 목표 유무에 따라 슛 생성 화면 상태값 수정
            journalCreatorStep = subGoals.isEmpty ? .shoot : .selectSubGoal
            
        }
        .sheet(isPresented: $isSettingsSheetPresented) {
            SettingsView() // 모달로 표시될 View
        }
    }
    /// 우측상단 버튼
    private var topTrailingButton: some View {
        HStack {
            Spacer()
            Button {
                manager.fullScreenMode = .chartView
            } label: {
                Image(systemName: "chart.bar.xaxis")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25)
            }
            .tint(.black)
            
            Button {
                isSettingsSheetPresented.toggle()
            } label: {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25)
            }
            .tint(.black)
        }
    }
    /// 목표현황 텍스트
    private var goalStatusText: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("목표(\(subGoals.count))")
                .font(.system(size: 22))
                .bold()
            Text("오늘은 어떤 목표에 시도했나요?")
                .font(.system(size: 18))
                .foregroundStyle(.secondary)
        }
        .padding(.bottom, 30)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    /// 목표 리스트
    private var subGoalList: some View {
        ScrollView {
            if !subGoals.isEmpty {
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(subGoals, id: \.self) { item in
                        let text = item.goalText ?? "목표 없음"
                        let count = journals.count(where: { $0.subGoal == item.goalText })
                        goalCell([text: count])
                    }
                }
                Color.clear
                    .frame(height: 200)
            } else {
                Text("목표를 생성해주세요!")
            }
        }
        .scrollIndicators(.hidden)
    }
    /// 목표 리스트 셀
    private func goalCell(_ data: [String: Int]) -> some View {
        var highlightColor: Color = .gray
        
        if let count = data.values.first {
            switch count {
            case 0..<3:
                highlightColor = .goalFreqLow
            case 3..<8:
                highlightColor = .goalFreqMid
            case 8...:
                highlightColor = .goalFreqHigh
            default:
                break
            }
        }
        
        return VStack(alignment: .leading) {
            if let goal = data.keys.first,
               let count = data.values.first {
                Text(goal)
                    .lineLimit(1)
										.foregroundStyle(.dashboardTitle)
                    .font(.system(size: 18))
                    .padding(.bottom, 10)
                    .minimumScaleFactor(0.7)
                HStack {
                    Spacer()
                    Text("\(count)번")
                        .font(.system(size: 14, weight: .bold))
												.foregroundStyle(.dashboardTitle)
                }
            } else {
                Text("데이터 없음")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(highlightColor)
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
    /// 하단 버튼
    private var bottomButton: some View {
        VStack {
            Spacer()
            Button {
                manager.fullScreenMode = .entryCreator
            } label: {
                Text("슛-쏘기")
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .bold()
                    .background(.tint)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 90))
            }
        }
    }
}
