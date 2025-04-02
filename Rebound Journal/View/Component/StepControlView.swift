//
//  StepControlView.swift
//  Rebound Journal
//
//  Created by 황석현 on 3/25/25.
//

import SwiftUI

struct StepControlView: View {
    // Action
    let onPrevious: () -> Void
    let onNext: () -> Void
    // UI State
    var canGoNext: Bool
    // Content
    var nextButtonText: String
    var previousButtonText: String = "이전"
    
    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let previousWidth = totalWidth * 0.25
            let nextWidth = totalWidth * 0.5
            
            HStack(alignment: .center) {
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
                        debugPrint("다음으로")
                        onNext()
                    }
                } label: {
                    Text(nextButtonText)
                        .frame(width: nextWidth)
                        .foregroundColor(.default)
                        .padding()
                        .cornerRadius(90)
                        .font(.system(size: 18, weight: .bold))
                        .background(Color.accentColor)
                        .foregroundColor(.default)
                        .cornerRadius(90)
                }
                .disabled(!canGoNext)
            }
            .padding()
        }
        .frame(height: 100)
    }
}

#Preview("Enabled") {
    StepControlView(onPrevious: {print("이전")}, onNext: {print("다음으로")}, canGoNext: true, nextButtonText: "다음으로")
}
#Preview("Disabled") {
    StepControlView(onPrevious: {print("이전")}, onNext: {print("다음으로")}, canGoNext: false, nextButtonText: "다음으로")
}
