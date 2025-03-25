//
//  ReviewPlanView.swift
//  Rebound Journal
//
//  Created by 황석현 on 3/19/25.
//

import SwiftUI

struct ReviewPlanView: View {
    
    let text = Constants.SystemText()
    @ObservedObject var viewModel: JournalCreatorViewModel
    @State var reviewText: String = ""
    @State var planText: String = ""
    
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
            Text(text.reviewShooting)
            TextField("오늘의 경험", text: $reviewText, prompt: Text("짧아도 좋아요. 경험에 대해 적어봐요."))
            Text(text.whatNextPlan)
            TextField("앞으로의 계획", text: $planText, prompt: Text("작은 것부터 생각해보아도 좋아요."))
            StepControlView(onPrevious: {
                
            }, onNext: {
                
            }, canGoNext: false,
            nextButtonText: "저장하기")
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
