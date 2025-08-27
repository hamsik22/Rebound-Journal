//
//  TargetList.swift
//  Rebound Journal
//
//  Created by 황석현 on 8/17/25.
//

import SwiftUI
import SwiftData

struct TargetList: View {
    
    @State private var activeTarget: [String: Int]?
    
    @Query private var subGoals: [SubGoalData]
    
    @State private var currentItem: Int = 0
    
    let dummys = [["미루지 말고 해보자": 2], ["살을 빼고 싶다": 1], ["개발을 잘하고 싶다": 0], ["힘이 세졌으면 좋겠다": 3], ["취업하기" : 3]]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 16) {
                    
                    goalStatusText
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<dummys.count, id: \.self) { num in
                                GeometryReader { cardGeo in
                                    let midX = cardGeo.frame(in: .global).midX
                                    let screenMidX = geo.size.width / 2
                                    
                                    let distance = abs(midX - screenMidX)
                                    
                                    Color.clear
                                        .onAppear {
                                            if distance < 50 {
                                                currentItem = num
                                            }
                                        }
                                        .onChange(of: distance) { _, newValue in
                                            if newValue < 50 {
                                                currentItem = num
                                            }
                                        }
                                    
                                    goalCell(dummys[num])
                                        .frame(width: geo.size.width * 0.6)
                                }
                                .frame(width: geo.size.width * 0.6)
                            }
                        }
                    }
                    .frame(height: geo.size.width * 0.25)
                    
                    HStack(spacing: 6) {
                        ForEach(0..<dummys.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentItem ? Color.white : Color.white.opacity(0.3))
                                .frame(width: 8, height:  8)
                                .animation(.easeInOut(duration: 0.2), value: currentItem)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        }
        .padding()
    }
    
    /// 목표현황 텍스트
    private var goalStatusText: some View {
        HStack {
            Text("목표 \(subGoals.count)개")
                .font(.system(size: 22, weight: .semibold))
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
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
}

#Preview {
    TargetList()
}

