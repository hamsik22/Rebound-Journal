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
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                ModalHeaderBar(title: "통계") {
                    manager.fullScreenMode = nil
                }
                Text("연속으로 2일째 기록 중이에요!")
                totalShoots
                chart
                    .frame(height: proxy.size.height * 0.3)
                shootLogs
            }
        }
    }
}

extension ChartView {
    
    /// 골 기록을 보여주는 차트화면
    /// 월별 갯수
    private var chart: some View {
        VStack {
            Text("차트화면")
        }
    }
    
    /// 골인/리바운드 갯수를 보여주는 버튼
    /// 누르면 상세보기로 넘어감
    private var totalShoots: some View {
        VStack {
            Text("전체 (32개)")
            HStack {
                Button {
                    print("골인 기록 보여주기")
                } label: {
                    VStack {
                        Text("골인")
                        Text("10개")
                    }
                }
                Button {
                    print("리바운드 기록 보여주기")
                } label: {
                    VStack {
                        Text("리바운드")
                        Text("12개")
                    }
                }
            }
        }
    }
    
    /// 슛 기록을 보여주는 화면
    /// 스크롤 뷰로 만들어야하고 날짜별로 보여줘야 함.
    private var shootLogs: some View {
        ScrollView {
            Text("asdf")
            Text("asdf")
            Text("asdf")
            Text("asdf")
        }
    }
}

#Preview {
    ChartView()
}
