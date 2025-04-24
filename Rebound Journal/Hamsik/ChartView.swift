//
//  ChartView.swift
//  Rebound Journal
//
//  Created by 황석현 on 4/1/25.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    @EnvironmentObject var manager: DataManager
    @State var date = Date()
    @State private var favoriteFruit = 1
    @FetchRequest(sortDescriptors: []) private var results: FetchedResults<JournalEntry>
    @ObservedObject var viewModel: ChartViewModel
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                ModalHeaderBar(title: "통계") {
                    manager.fullScreenMode = nil
                }
                streakText
                totalShoot(data: viewModel.journalSummary)
                chart
                    .frame(height: proxy.size.height * 0.3)
                shootLog
            }
        }
    }
}

extension ChartView {
    
    /// 연속기록 일수를 보여주는 화면
    private var streakText: some View {
        HStack {
            Text("연속으로 \(viewModel.journalSummary.streak)일째 기록 중이에요!")
                .font(.title2.bold())
            Spacer()
        }
        .padding(.horizontal)
        .onAppear {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"

            let sorted = viewModel.journals
                .filter { !$0.hasDeleted }
                .sorted { $0.date < $1.date }
            
            let dateStrings = sorted.map { formatter.string(from: $0.date) }

            dateStrings.forEach { debugPrint($0) }
        }
    }
    
    /// 골 기록을 보여주는 차트화면
    /// 월별 갯수
    private var chart: some View {
        VStack {
            HStack {
                Text("월별")
                    .bold()
                Button {
                } label: {
                    HStack {
                        Text("3월")
                        Image(systemName: "chevron.up.chevron.down")
                    }
                }
                
                Spacer()
                
                customChartLegend(circleColor: .orange, text: "골인")
                customChartLegend(circleColor: .orange.opacity(0.2), text: "리바운드")
            }
            
            Chart {
                ForEach(viewModel.journalChart) { item in
                    BarMark(
                        x: .value("Date", item.date.dayLabel),
                        y: .value("Count", item.count)
                    )
                    .foregroundStyle(item.isGoalIn ? Color.orange : Color.orange.opacity(0.2))
                }
            }
            .chartLegend(.hidden)
        }
        .padding()
    }
    
    func customChartLegend(circleColor: Color, text: String) -> some View {
        HStack {
            Circle()
                .foregroundStyle(circleColor)
                .scaledToFit()
            Text(text)
                .font(.system(size: 12))
        }
        .frame(height: 12)
    }
    
    /// 골인/리바운드 갯수를 보여주는 버튼
    /// 누르면 상세보기로 넘어감
    private func totalShoot(data: JournalSummary) -> some View {
        VStack {
            HStack{
                Text("전체 (\(data.total)개)")
                    .font(.title2.bold())
                Spacer()
            }
            HStack {
                Button {
                    print("골인 기록 보여주기")
                } label: {
                    VStack {
                        Text("골인")
                            .bold()
                            .padding(.bottom, 2)
                        Text("\(data.goals)개")
                            .font(.title.bold())
                    }
                    .padding()
                    .frame(height: 80)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.default)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                }
                
                Button {
                    print("리바운드 기록 보여주기")
                } label: {
                    VStack {
                        Text("리바운드")
                            .bold()
                            .padding(.bottom, 2)
                        Text("\(data.rebounds)개")
                            .font(.title.bold())
                    }
                }
                .padding()
                .frame(height: 80)
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.default)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2)
                )
            }
        }
        .padding()
    }
    
    /// 슛 기록을 보여주는 화면
    /// 스크롤 뷰로 만들어야하고 날짜별로 보여줘야 함.
    private var shootLog: some View {
        VStack {
            ForEach(viewModel.groupedJournalData, id: \.key) { group in
                VStack(alignment: .leading, spacing: 10) {
                    Text(group.key)
                        .font(.title3.bold())
                        .opacity(0.5)
                        .padding(.leading, 5)

                    ForEach(group.value) { item in
                        VStack(alignment: .leading) {
                            Text("\(item.isGoalIn ? "골인" : "리바운드") - \(item.emotionText)")
                                .bold()
                                .padding(.bottom, 10)
                            Text(item.review)
                            Divider()
                            Text(item.nextPlan)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                }
            }
        }
        .padding()
    }
}


#Preview {
    ChartView(viewModel: ChartViewModel())
}
