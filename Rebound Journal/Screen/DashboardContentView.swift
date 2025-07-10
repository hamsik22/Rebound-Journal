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
    
    private let dummyGoals: [SubGoalData] = [
        SubGoalData(id: UUID().uuidString, date: Date(), goalText: "미루지 말고 해보자"),
        SubGoalData(id: UUID().uuidString, date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, goalText: "하루 10분 독서하기"),
        SubGoalData(id: UUID().uuidString, date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, goalText: "물 2리터 마시기"),
        SubGoalData(id: UUID().uuidString, date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, goalText: "30분 산책하기"),
        SubGoalData(id: UUID().uuidString, date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, goalText: "뉴스 읽기"),
        SubGoalData(id: UUID().uuidString, date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, goalText: "간단한 요리해보기"),
        SubGoalData(id: UUID().uuidString, date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, goalText: "노트 정리하기"),
        SubGoalData(id: UUID().uuidString, date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, goalText: "앱 리팩토링 1시간"),
        SubGoalData(id: UUID().uuidString, date: Calendar.current.date(byAdding: .day, value: -8, to: Date())!, goalText: "운동 스트레칭하기")
    ]
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
    
    // MARK: 01. 뷰를 따로 떼어놓는 것에 대한 방법
    private var MainContainer: some View {
        VStack(spacing: 15) {
            topTrailingButton
            goalStatusText
            subGoalList
            Spacer()
        }
    }
    
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
        .padding()
    }
    private var goalStatusText: some View {
        VStack(alignment: .leading, spacing: 12) {
            // TODO: 목표 갯수 연동
            Text("목표(8)")
                .font(.system(size: 22))
                .bold()
            Text("오늘은 어떤 목표에 시도했나요?")
                .font(.system(size: 18))
                .foregroundStyle(.secondary)
        }
        .padding(.bottom, 30)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    private var subGoalList: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 24) {
                // TODO: 목표 리스트 연동
                ForEach(dummyGoals, id: \.self) { item in
                    let text = item.goalText ?? "목표 없음"
                    let count = Int.random(in: 0...10)
                    goalCell([text: count])
                }
            }
            Color.clear
                .frame(height: 200)
        }
        .scrollIndicators(.hidden)
    }
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
                    .font(.system(size: 18))
                    .padding(.bottom, 10)
                    .minimumScaleFactor(0.7)
                HStack {
                    Spacer()
                    Text("\(count)번")
                        .font(.system(size: 14, weight: .bold))
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
    private var bottomButton: some View {
        VStack {
            Spacer()
            VStack {
                Button {
                    // TODO: 목표 추가하기 화면으로 이동
                    print("목표 추가하기 버튼")
                } label: {
                    Text("목표 추가하기")
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .bold()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 90))
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 90)
                        .stroke(Color.orange, lineWidth: 2)
                )
                
                Button {
                    // TODO: 슛 생성 화면으로 이동
                    print("슛-쏘기 버튼")
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
}
