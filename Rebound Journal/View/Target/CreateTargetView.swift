//
//  CreateTargetView.swift
//  Rebound Journal
//
//  Created by 황석현 on 5/5/25.
//

import SwiftUI
import SwiftData

struct CreateTargetView: View {
    
    @Environment(\.modelContext)private var modelContext
    @EnvironmentObject var manager: DataManager
    @State var targetText: String = ""
    @ObservedObject var viewModel: JournalCreatorViewModel
    
    var body: some View {
        // 전체
        VStack {
            // MARK: 안내문구 1
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("이번 슈팅에 대한")
                        .font(.system(size: 18))
                    Spacer()
                }
                HStack {
                    Text("목표를 생성할까요?")
                        .font(.system(size: 25).bold())
                    Spacer()
                }
            }
            .padding(.bottom)
            
            // MARK: 목표 입력
            VStack(alignment: .leading) {
                Text("목표가 눈에 보이면, 동기부여의 효과가 있어요!")
                    .font(.system(size: 13))
                HStack {
                    TextEditor(text: $targetText)
                        .font(.system(size: 15))
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .scrollContentBackground(.hidden)
                        .overlay(alignment: .leading) {
                            if targetText.isEmpty {
                                Text("목표를 적어주세요")
                                    .font(.system(size: 15))
                                    .padding(.horizontal, 10)
                                    .opacity(0.3)
                            }
                        }
                    Text("\(targetText.count)/30")
                        .font(.system(size: 12))
                        .padding(.horizontal, 5)
                }
                .frame(height: 65)
                .padding(5)
                .background(Color("CellColor"))
                .clipShape(.rect(cornerRadius: 12))
            }
            
            Spacer()
            
            // MARK: 안내문구 2
            Text("다음 슈팅 때 선택할 수 있어요.\n언제든지 다시 확인할 수 있어요.")
                .multilineTextAlignment(.center)
            
            StepControlView(
                onPrevious: {
                print("이전")
                viewModel.currentStep = .review
            },
                onNext: {
                print("저장하기")
                viewModel.subGoal = targetText
                viewModel.saveJournal(context: modelContext)
                viewModel.saveSubGoal(context: modelContext)
                manager.fullScreenMode = nil
                viewModel.currentStep = .selectSubGoal
            },
                canGoNext: !targetText.isEmpty,
                nextButtonText: "저장하기")
        }
        .padding()
    }
}

#Preview("!targetText.isEmpty") {
    CreateTargetView(viewModel: JournalCreatorViewModel())
}
#Preview("targetText.isEmpty") {
    CreateTargetView(targetText: "", viewModel: JournalCreatorViewModel())
}
