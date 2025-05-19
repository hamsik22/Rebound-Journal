//
//  JounrnalCreator.swift
//  Rebound Journal
//
//  Created by 황석현 on 3/21/25.
//

import SwiftUI
import SwiftData

struct JounrnalCreator: View {
    // Shared Dependencies
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var manager: DataManager
    @ObservedObject var viewModel: JournalCreatorViewModel
    // UI State
    @Binding var currentStep: ReboundProcessStep
    @State private var showAlert: Bool = false
    @Query private var subGoals: [SubGoalData]
    
    var body: some View {
        VStack {
            ModalHeaderBar(onDismiss:  {
                manager.fullScreenMode = nil
            }, hasAlert: true)
            switch currentStep {
            case .selectSubGoal: SelectTargetView(viewModel: viewModel, currentStep: $currentStep, subGoals: subGoals)
            case .shoot: SelectShootTypeView(viewModel: viewModel, currentStep: $currentStep)
            case .emotion: EmotionInputView(viewModel: viewModel, currentStep: $currentStep)
            case .review: ReviewPlanView(viewModel: viewModel, currentStep: $currentStep)
                    .environmentObject(manager)
            case .createSubGoal: CreateTargetView(viewModel: viewModel, currentStep: $currentStep)
                    .environmentObject(manager)
            }
        }
    }
}

#Preview {
    JounrnalCreator(viewModel: JournalCreatorViewModel(), currentStep: .constant(.createSubGoal))
        .environmentObject(DataManager())
}
