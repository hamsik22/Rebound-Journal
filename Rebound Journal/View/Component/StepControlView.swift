//
//  StepControlView.swift
//  Rebound Journal
//
//  Created by 황석현 on 3/25/25.
//

import SwiftUI

// MARK: 하단의 <이전><다음으로> 버튼을 만드는 뷰

/// - onPrevious : <이전>을 눌렀을 때, 동작할 코드
/// - onNext : <다음으로>을 눌렀을 때, 동작할 코드
/// - canGoNext : <다음으로>를 활성화하는 Bool값
/// - nextButtonText : <다음으로>가 아닌 다른 문자로 수정할 시
/// - previousButtonText : <이전>이 아닌 다른 문자로 수정할 시
struct StepControlView: View {
    // Action
    let onPrevious: () -> Void
    let onNext: () -> Void
    // UI State
    var canGoNext: Bool
    // Content
    var nextButtonText: String = "다음으로"
    var previousButtonText: String = "이전"
    
    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let previousWidth = totalWidth * 0.25
            let nextWidth = totalWidth * 0.57
            
            HStack {
                Button {
                    onPrevious()
                } label: {
                    Text(previousButtonText)
                        .frame(width: previousWidth)
                        .tint(.default)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 90)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                }
                
                Button {
                    if canGoNext {
                        print("다음으로")
                        onNext()
                    }
                } label: {
                    Text(nextButtonText)
                        .frame(width: nextWidth)
                        .foregroundColor(canGoNext ? .white : .black.opacity(0.5))
                        .padding()
                        .cornerRadius(90)
                        .font(.system(size: 18, weight: .bold))
                        .background(Color.accentColor)
                        .foregroundColor(.default)
                        .cornerRadius(90)
                }
                .disabled(!canGoNext)
            }
        }
        .frame(height: 60)
    }
}

#Preview("Enabled") {
    StepControlView(onPrevious: {print("이전")}, onNext: {print("다음으로")}, canGoNext: true, nextButtonText: "다음으로")
}
#Preview("Disabled") {
    StepControlView(onPrevious: {print("이전")}, onNext: {print("다음으로")}, canGoNext: false, nextButtonText: "다음으로")
}
