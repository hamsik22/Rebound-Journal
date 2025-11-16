//
//  AllJournalList.swift
//  Rebound Journal
//
//  Created by 황석현 on 11/14/25.
//

import SwiftUI
import SwiftData

/// HomeView의 우측상단 버튼 중 첫 번째 버튼을 눌렀을 때, 이동되는 화면
struct AllJournalList: View {
    
    @EnvironmentObject var manager: DataManager
    
    var body: some View {
        VStack {
            
            // Header
            HStack {
                Spacer()
                
                Text("전체 기록")
                    .font(.system(size: 18, weight: .semibold))
                
                Spacer()
                
                Button {
                    manager.fullScreenMode = nil
                    print("전체 기록화면 닫기")
                } label: {
                    Image(systemName: "xmark")
                        .bold()
                }
                .tint(.black)
            }
            .padding()
            
            // Content
            JournalCell()
        }
    }
}

// JournalList가 적절해보이는데 중복되는 이름이 있어서 보류
private struct JournalCell: View {
    /// JournalCell에 필요한 데이터 형태가 뭐지?
    /// JournalData와 subGoals를 합쳐야하나?
    @Query private var journals: [JournalData]
    
    var body: some View {
        ScrollView {
            ForEach(journals) { item in
                HStack {
                    Text("목표")
                        .foregroundStyle(.orange)
                    Text(item.subGoalUnwrapped)
                        .font(.system(size: 18, weight: .semibold))
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    Text(item.nextPlanUnwrapped)
                        .font(.system(size: 20, weight: .semibold))
                        .padding(4)
                    Text(item.reviewUnwrapped)
                        .font(.system(size: 13))
                        .foregroundStyle(.gray)
                        .padding(4)
                    
                    
                    HStack {
                        Spacer()
                        Text(item.isGoalInUnwrapped ? "골인" : "리바운드")
                            .font(.system(size: 13))
                            .foregroundStyle(.gray)
                        
                        Image(systemName: "circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 4)
                            .foregroundStyle(.gray)
                        
                        Text("하루 전")
                            .font(.system(size: 13))
                            .foregroundStyle(.gray)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.gray.opacity(0.1))
            }
        }
        .padding()
        .scrollIndicators(.hidden)
    }
    
    var data: [JournalData] = [
        JournalData(
            id: UUID().uuidString,
            date: Date(),
            hasDeleted: false,
            isGoalIn: Bool.random(),
            emotionValue: 1,
            emotionText: "감정태그 1",
            review: "느낀 점",
            nextPlan: "향후 계획 1",
            isRebounded: false,
            purpose: nil,
            mainGoal: nil,
            subGoal: "목표 1"
        ),

        JournalData(
            id: UUID().uuidString,
            date: Date(),
            hasDeleted: false,
            isGoalIn: Bool.random(),
            emotionValue: 0,
            emotionText: "감정태그 0",
            review: "리뷰 0",
            nextPlan: "계획 0",
            isRebounded: false,
            purpose: nil,
            mainGoal: nil,
            subGoal: "목표 1"
        ),

        JournalData(
            id: UUID().uuidString,
            date: Date(),
            hasDeleted: false,
            isGoalIn: Bool.random(),
            emotionValue: 2,
            emotionText: "감정태그 2",
            review: "리뷰 2",
            nextPlan: "계획 2",
            isRebounded: false,
            purpose: nil,
            mainGoal: nil,
            subGoal: "목표 2"
        ),

        JournalData(
            id: UUID().uuidString,
            date: Date(),
            hasDeleted: false,
            isGoalIn: Bool.random(),
            emotionValue: 3,
            emotionText: "감정태그 3",
            review: "리뷰 3",
            nextPlan: "계획 3",
            isRebounded: false,
            purpose: nil,
            mainGoal: nil,
            subGoal: "목표 3"
        ),

        JournalData(
            id: UUID().uuidString,
            date: Date(),
            hasDeleted: false,
            isGoalIn: Bool.random(),
            emotionValue: 1,
            emotionText: "감정태그 1",
            review: "리뷰 1-2",
            nextPlan: "계획 1-2",
            isRebounded: false,
            purpose: nil,
            mainGoal: nil,
            subGoal: "목표 2"
        )
    ]
}

#Preview {
    AllJournalList()
}
