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
    @State private var path = NavigationPath()
    
    var body: some View {
        VStack {
            ModalHeaderBar(onDismiss:  {
                manager.fullScreenMode = nil
            }, hasAlert: true)
            NavigationStack(path: $path) {
                SelectTargetView(viewModel: viewModel, subGoals: subGoals, path: $path)
                    .navigationDestination(for: JournalCreationState.self) { value in
                        switch value {
                        case .createSubGoal:
                            CreateTargetView(viewModel: viewModel, path: $path)
                                .navigationBarBackButtonHidden()
                        case .selectSubGoal:
                            SelectTargetView(viewModel: viewModel, subGoals: subGoals, path: $path)
                                .navigationBarBackButtonHidden()
                        case .shoot:
                            SelectShootTypeView(viewModel: viewModel, path: $path)
                                .navigationBarBackButtonHidden()
                        case .emotion:
                            EmotionInputView(viewModel: viewModel, path: $path)
                                .navigationBarBackButtonHidden()
                        case .review:
                            ReviewPlanView(viewModel: viewModel, path: $path)
                                .navigationBarBackButtonHidden()
                        }
                    }
            }
        }
    }
}

enum JournalCreationState: Hashable {
    case selectSubGoal,
         shoot,
         emotion,
         review,
         createSubGoal
}

#Preview {
    JounrnalCreator(viewModel: JournalCreatorViewModel(), currentStep: .constant(.createSubGoal))
        .environmentObject(DataManager())
}
