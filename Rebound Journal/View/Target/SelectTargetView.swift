//
//  SelectTargetView.swift
//  Rebound Journal
//
//  Created by 황석현 on 5/5/25.
//

import SwiftUI
import SwiftData

struct SelectTargetView: View {
    // Shared Dependencies
    @ObservedObject var viewModel: JournalCreatorViewModel
    @Binding var currentStep: ReboundProcessStep
    // UI State
    @State var subGoals: [SubGoalData]
    @State private var selectedGoal: SubGoalData?
    
    var body: some View {
        VStack {
            // 질문
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("어떤 슛을 남겨볼까요?")
                        .font(.system(size: 25).bold())
                    Spacer()
                }
                HStack {
                    Text("목표에 대한 슛인가요?")
                        .font(.system(size: 18))
                        .opacity(0.5)
                    Spacer()
                }
            }
            .padding(.vertical)
            
            // 목표 리스트
            VStack(alignment: .leading, spacing: 8) {
                ForEach(subGoals, id: \.self) { item in
                    if let text = item.goalText {
                        HStack {
                            Text(text)
                                .padding()
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color("CellColor"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selectedGoal == item ? Color.accentColor : .clear, lineWidth: 2)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .onTapGesture {
                            selectedGoal = item
                            viewModel.subGoal = item.goalText
                        }
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                debugPrint("다음 화면으로 이동")
                currentStep = .shoot
            }) {
                if let _ = selectedGoal {
                    Text("다음으로")
                        .font(.system(size: 18, weight: .bold))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .clipShape(.rect(cornerRadius: 90))
                } else {
                    Text("건너뛰기")
                        .font(.system(size: 18, weight: .bold))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .clipShape(.rect(cornerRadius: 90))                    
                }
            }
            .disabled(false)
            .animation(.easeInOut, value: 1)
        }
        .padding()
        .onAppear {
            debugPrint("SelectTargetView : \(subGoals.count)")
        }
    }
}

#Preview {
    SelectTargetView(viewModel: JournalCreatorViewModel(), currentStep: .constant(.createSubGoal), subGoals: [])
}
