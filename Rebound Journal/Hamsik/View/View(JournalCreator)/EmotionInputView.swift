//
//  RecordFeelingView.swift
//  Rebound Journal
//
//  Created by 황석현 on 3/19/25.
//

import SwiftUI

struct EmotionInputView: View {
    
    @State private var sliderValue: Double = 0.5
    @ObservedObject var viewModel: JournalCreatorViewModel
    
    var body: some View {
        VStack {
            if let type = viewModel.goalType {
                ShootCreationHeader(
                    title: type ? Constants.Strings.EmotionInPutGoalIn :
                        Constants.Strings.EmotionInPutRebound,
                    image: type ? .goalIn : .rebound)
            }
            HStack {
                FeelingTracker(viewModel: viewModel)
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
    
    private var verticalSlider: some View {
        VStack {
            Text("부정")
            ZStack {
                Color.clear
                    .frame(width: 30, height: 400) // 원하는 크기의 컨테이너
                    .overlay(
                        Slider(value: $sliderValue, in: 0...3, step: 1)
                            .rotationEffect(.degrees(-90))
                            .frame(width: 400, height: 30)) // 원래 크기 유지
            }
            .animation(.easeIn(duration: 0.3), value: sliderValue)
            Text("긍정")
        }
    }
}

#Preview("EmotionInputView") {
    EmotionInputView(viewModel: JournalCreatorViewModel())
}
