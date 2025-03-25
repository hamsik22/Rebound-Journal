//
//  ReviewPlanView.swift
//  Rebound Journal
//
//  Created by 황석현 on 3/19/25.
//

import SwiftUI

struct ReviewPlanView: View {
    
    let text = Constants.ContentText()
    let systemText = Constants.SystemText()
    @ObservedObject var viewModel: JournalCreatorViewModel
    @State var reviewText: String = ""
    @State var planText: String = ""
    var canSave: Bool {
        guard let reviewText = viewModel.reviewText else { return false }
        guard let planText = viewModel.nextPlanText else { return false }
        return !reviewText.isEmpty && !planText.isEmpty
    }
    
    var body: some View {
        VStack {
            Text(viewModel.emotionText?.first ?? "감정태그")
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .frame(height: 35)
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .background {
                    Capsule()
                        .fill(.accent.gradient)
                }
            
            // Reviewing Shoot
            Text(text.reviewShooting)
            TextField("오늘의 경험", text: $reviewText, prompt: Text(text.reviewShootingField))
            
            // Get NextPlan
            Text(text.whatNextPlan)
            TextField("앞으로의 계획", text: $planText, prompt: Text(text.whatNextPlanField))
            
            // StepControll
            StepControlView(onPrevious: {
                viewModel.currentStep = .emotion
            }, onNext: {
                // TODO: 저장 로직
            }, canGoNext: canSave,
            nextButtonText: systemText.nextButton)
        }
    }
}

#Preview {
    let mockViewModel = {
        let vm = JournalCreatorViewModel()
        vm.goalType = true
        vm.currentStep = .review
        vm.emotionValue = 1
        vm.emotionText = ["기분이 좋은"]
        return vm
    }()
    ReviewPlanView(viewModel: mockViewModel)
}
