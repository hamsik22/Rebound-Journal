//
//  StepControlView.swift
//  Rebound Journal
//
//  Created by 황석현 on 3/25/25.
//

import SwiftUI

struct StepControlView: View {
    
    let onPrevious: () -> Void
    let onNext: () -> Void
    var canGoNext: Bool
    
    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let previousWidth = totalWidth * 0.25
            let nextWidth = totalWidth * 0.5
            
            HStack(alignment: .center) {
                Button {
                    debugPrint("이전")
                } label: {
                    Text("이전")
                        .frame(width: previousWidth)
                        .tint(.black)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 90)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                }
                
                Button {
                    if canGoNext {
                        debugPrint("다음으로")
                    }
                } label: {
                    Text("다음으로")
                        .frame(width: nextWidth)
                        .foregroundColor(.white)
                        .padding()
                        .cornerRadius(90)
                        .font(.system(size: 18, weight: .bold))
                        .background(Color.accentColor)
                        .foregroundColor(.white)
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
    StepControlView(onPrevious: {print("이전")}, onNext: {print("다음으로")}, canGoNext: true)
}
#Preview("Disabled") {
    StepControlView(onPrevious: {print("이전")}, onNext: {print("다음으로")}, canGoNext: false)
}
