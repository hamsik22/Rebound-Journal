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
    var mockChartData: [ChartItem] = [
        .init(date: 12, isTypeA: true, count: 5),
        .init(date: 12, isTypeA: false, count: 1),
        .init(date: 13, isTypeA: true, count: 0),
        .init(date: 13, isTypeA: false, count: 2),
        .init(date: 14, isTypeA: true, count: 4)
    ]
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                ModalHeaderBar(title: "통계") {
                    manager.fullScreenMode = nil
                }
                // TODO: 연속 일수 필요
                streakText
                // TODO: 현재 데이터의 현황(전체/슛/리바운드 갯수)
                totalShoot(data: viewModel.journalSummary)
                // TODO: 차트를 보여준다
                chart
                    .frame(height: proxy.size.height * 0.3)
                // TODO: 차트에서 보여지는 슛의 기록들을 보여준다.
                shootLog(data: viewModel.journalData)
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
                ForEach(mockChartData) { item in
                    BarMark(
                        x: .value("Date", "\(item.date)"),
                        y: .value("Count", item.count)
                    )
                    .foregroundStyle(item.isTypeA ? Color.orange : Color.orange.opacity(0.2))
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
    private func shootLog(data: [JournalMetaData]) -> some View {
        VStack {
            HStack {
                Text("3.18")
                    .font(.title3.bold())
                    .opacity(0.5)
                    .padding(.leading, 5)
                Spacer()
            }
            ScrollView {
                ForEach(data) { item in
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
        .padding()
    }
}


#Preview {
    ChartView(viewModel: ChartViewModel())
}

// 추후 작업예정
struct ChartItem : Identifiable {
    let id = UUID()
    let date: Int
    let isTypeA: Bool
    let count: Int
}
