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
    @State private var showAlert: Bool = false
    @Query private var subGoals: [SubGoalData]
    
    var body: some View {
        VStack {
            ModalHeaderBar(onDismiss:  {
                manager.fullScreenMode = nil
            }, hasAlert: true)
            switch viewModel.currentStep {
            case .selectSubGoal: SelectTargetView(viewModel: viewModel, subGoals: subGoals)
            case .shoot: SelectShootTypeView(viewModel: viewModel)
            case .emotion: EmotionInputView(viewModel: viewModel)
            case .review: ReviewPlanView(viewModel: viewModel)
                    .environmentObject(manager)
            case .createSubGoal: CreateTargetView(viewModel: viewModel)
                    .environmentObject(manager)
            }
        }
    }
}

#Preview {
    JounrnalCreator(viewModel: JournalCreatorViewModel())
        .environmentObject(DataManager())
}
