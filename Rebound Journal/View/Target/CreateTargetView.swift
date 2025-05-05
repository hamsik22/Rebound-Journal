//
//  CreateTargetView.swift
//  Rebound Journal
//
//  Created by 황석현 on 5/5/25.
//

import SwiftUI

struct CreateTargetView: View {
    
    @State var targetText: String = "계획을 세우고 실천하면 매일이 성장의 기회가 됩니다@@"
    
    var body: some View {
        GeometryReader { proxy in
            // 전체
            VStack {
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
                    .padding(.vertical)
                    
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
                            Text("\(targetText.count)/30")
                                .font(.system(size: 12))
                                .padding(.horizontal, 5)
                        }
                        .frame(height: 65)
                        .padding(5)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(.rect(cornerRadius: 18))
                    }
                    
                    Spacer()
                    
                    // MARK: 안내문구 2
                    Text("다음 슈팅 때 선택할 수 있어요.\n언제든지 다시 확인할 수 있어요.")
                        .multilineTextAlignment(.center)
                    
                }
                .padding()
                StepControlView(onPrevious: {print(" 이전")}, onNext: {print("저장하기")}, canGoNext: !targetText.isEmpty, nextButtonText: "저장하기")
            }
            
            
        }
    }
}

#Preview {
    CreateTargetView()
}
