//
//  JournalDetail.swift
//  Rebound Journal
//
//  Created by 황석현 on 11/17/25.
//

import SwiftUI

struct JournalDetail: View {
    
    @EnvironmentObject var manager: DataManager
    var journal: JournalData?
    
    var body: some View {
        
        VStack {
            // Header
            HStack {
                Button {
                    manager.fullScreenMode = nil
                    print("뒤로가기")
                } label: {
                    Image(systemName: "chevron.backward")
                }
                .tint(.black)
                
                
                Text("기록")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(maxWidth: .infinity)
                
                
                Button {
                    print("삭제하기")
                } label: {
                    Text("삭제")
                        .font(.system(size: 18, weight: .semibold))
                }
            }
            .padding(.bottom, 12)
            
            
            // subGoal
            VStack(alignment: .leading) {
                Text("목표")
                    .font(.system(size: 22, weight: .semibold))
                Text(journal?.subGoalUnwrapped ?? "목표 1")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .background(.orange.opacity(0.3))
                    .clipShape(RoundedCorner(radius: 12))
            }
            .padding(.vertical)
            
            // Plan
            VStack(alignment: .leading) {
                Text("계획")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.red)
                Text(data[0].nextPlanUnwrapped)
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .background(.orange.opacity(0.3))
                    .clipShape(RoundedCorner(radius: 12))
            }
            .padding(.vertical)
            
            // Journal Detail
            VStack(alignment: .leading) {
                HStack {
                    Text(journal?.isReboundedUnwrapped ?? true ? "리바운드" : "골인")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.red)
                    Text(journal?.emotionTextUnwrapped ?? "감정태그")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.red)
                        .padding(10)
                        .background(.orange.opacity(0.3))
                        .clipShape(.capsule)
                }
                Text(journal?.reviewUnwrapped ?? "느낀 점")
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .background(.orange.opacity(0.3))
                    .clipShape(RoundedCorner(radius: 12))
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                
            }
            
            Spacer()
            
            // Delete Button
            Button {
                
            } label: {
                Text("삭제하기")
                    .font(.system(size: 18, weight: .semibold))
            }
            
        }
        .padding()
        
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
    JournalDetail()
}
