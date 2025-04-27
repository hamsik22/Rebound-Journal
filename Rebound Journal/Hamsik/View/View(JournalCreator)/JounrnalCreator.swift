//
//  JounrnalCreator.swift
//  Rebound Journal
//
//  Created by 황석현 on 3/21/25.
//

import SwiftUI

struct JounrnalCreator: View {
    // Shared Dependencies
    @EnvironmentObject var manager: DataManager
    @ObservedObject var viewModel: JournalCreatorViewModel
    // UI State
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack {
            TopProgressBarView
            switch viewModel.currentStep {
            case .shoot: SelectShootTypeView(viewModel: viewModel)
            case .emotion: EmotionInputView(viewModel: viewModel)
            case .review: ReviewPlanView(viewModel: viewModel)
                    .environmentObject(manager)
            }
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private var TopProgressBarView: some View {
        HStack {
            Spacer()
            Button {
                manager.fullScreenMode = nil
            } label: {
                Image(systemName: Constants.ImageStrings.xMark)
                    .font(.system(size: 20, weight: .semibold))
                    .tint(.default)
                    .padding()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(Constants.Strings.exitFlow),
                      message: Text(Constants.Strings.exitDescription),
                      primaryButton: .default(Text("OK"), action: {
                    manager.fullScreenMode = nil
                }),
                      secondaryButton: .cancel(Text("Cancel"))
                )
            }
        }
    }
}

#Preview {
    JounrnalCreator(viewModel: JournalCreatorViewModel())
        .environmentObject(DataManager())
}
