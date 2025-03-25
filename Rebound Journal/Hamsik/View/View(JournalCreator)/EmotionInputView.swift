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
    
    var canGoNext: Bool {
        viewModel.emotionValue != nil && (viewModel.emotionText != [] && viewModel.emotionText != nil)
    }
    
    var body: some View {
        VStack {
            if let type = viewModel.goalType {
                ShootCreationHeader(
                    title: type ? Constants.Strings.EmotionInPutGoalIn :
                        Constants.Strings.EmotionInPutRebound,
                    image: type ? .goalIn : .rebound)
            }
            EmotionTracker(viewModel: viewModel)
                .frame(maxWidth: .infinity)
                .padding()
            Spacer()
            StepControlView(onPrevious: {
                viewModel.currentStep = .shoot
            }, onNext: {
                viewModel.currentStep = .review
            }, canGoNext: canGoNext,
            nextButtonText: "다음으로")
        }
    }
    
    private var verticalSlider: some View {
        VStack {
            Text("부정")
            ZStack {
                Color.clear
                    .frame(width: 30, height: 400)
                    .overlay(
                        Slider(value: $sliderValue, in: 0...3, step: 1)
                            .rotationEffect(.degrees(-90))
                            .frame(width: 400, height: 30))
            }
            .animation(.easeIn(duration: 0.3), value: sliderValue)
            Text("긍정")
        }
    }
}

#Preview("EmotionInputView: GoalIn") {
    let viewModel: JournalCreatorViewModel = {
           let vm = JournalCreatorViewModel()
           vm.goalType = true
           return vm
       }()
    EmotionInputView(viewModel: viewModel)
}

#Preview("EmotionInputView: Rebound") {
    let viewModel: JournalCreatorViewModel = {
           let vm = JournalCreatorViewModel()
           vm.goalType = false
           return vm
       }()
    EmotionInputView(viewModel: viewModel)
}
