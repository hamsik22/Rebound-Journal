//
//  ReviewPlanView.swift
//  Rebound Journal
//
//  Created by 황석현 on 3/19/25.
//

import SwiftUI

struct ReviewPlanView: View {
    /// 텍스트 필드를 구분하기 위한 열거형
    private enum Field {
        case review
        case plan
    }
    // Shared Dependencies
    @ObservedObject var viewModel: JournalCreatorViewModel
    @EnvironmentObject var manager: DataManager
    @Environment(\.modelContext) private var modelContext
    
    // UI State
    @FocusState private var currentField: Field?
    @State var reviewText: String = ""
    @State var planText: String = ""
    @Binding var currentStep: ReboundProcessStep
    var canSave: Bool { return !reviewText.isEmpty && !planText.isEmpty }
    var isReviewed: Bool {!reviewText.isEmpty || currentField == .review}
    var isPlaned: Bool {!planText.isEmpty || currentField == .plan}
    
    // etc
    let text = Constants.ContentText()
    let systemText = Constants.SystemText()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.emotionText?.first ?? "감정태그")
                .font(.system(size: 16))
								.foregroundStyle(.black)
                .padding(.horizontal, 10)
								.padding(.vertical, 12)
                .background {
                    Capsule()
												.fill(.unselectedTagBackground)
                }
            
            // Reviewing Shoot
            if (currentField == .review) || (currentField == .none) {
                Text(text.reviewShooting)
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
                    .padding(.bottom, 3)
                    .foregroundStyle(currentField == .review ? .default : .gray)
                TextEditor(text: $reviewText)
                    .onChange(of: reviewText) { _, newValue in
                        viewModel.reviewText = newValue
                    }
                    .focused($currentField, equals: .review)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .frame(alignment: .topLeading)
                    .padding()
                    .scrollContentBackground(.hidden)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(.rect(cornerRadius: 18))
                    .overlay(alignment: .topLeading) {
                        Text(text.reviewShootingField)
                            .foregroundStyle(isReviewed ? .clear : .gray)
                            .padding()
                    }
            }
            
            if (currentField == .plan) || (currentField == .none) {
                // Get NextPlan
                Text(text.whatNextPlan)
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
                    .padding(.bottom, 3)
                    .foregroundStyle(currentField == .plan ? .default : .gray)
                TextEditor(text: $planText)
                    .onChange(of: planText) { _, newValue in
                        viewModel.nextPlanText = newValue
                    }
                    .focused($currentField, equals: .plan)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .frame(alignment: .topLeading)
                    .padding()
                    .scrollContentBackground(.hidden)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(.rect(cornerRadius: 18))
                    .overlay(alignment: .topLeading) {
                        Text(text.whatNextPlanField)
                            .foregroundStyle(isPlaned ? .clear : .gray)
                            .padding()
                    }
            }
            
            // StepControll
            StepControlView(
                hasBackButton: true,
                canGoNext: canSave,
                onPrevious: {
                    currentStep = .emotion
                },
                onNext: {
                    if viewModel.subGoal != nil {
                        viewModel.saveJournal(context: modelContext)
                        currentStep = .selectSubGoal
                        manager.fullScreenMode = nil
                    }
                    else { currentStep = .createSubGoal }
                    
                },
                nextButtonText: (viewModel.subGoal != nil) ? systemText.saveButton : systemText.nextButton
            )
        }
        .onTapGesture {
            currentField = .none
        }
        .onAppear() {
            reviewText = viewModel.reviewText ?? ""
            planText = viewModel.nextPlanText ?? ""
        }
        .padding()
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
    ReviewPlanView(viewModel: mockViewModel, currentStep: .constant(.review))
}
