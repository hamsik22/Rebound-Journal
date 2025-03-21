//
//  JounrnalCreator.swift
//  Rebound Journal
//
//  Created by 황석현 on 3/21/25.
//

import SwiftUI

struct JounrnalCreator: View {
    @EnvironmentObject var manager: DataManager
    @ObservedObject var viewModel: JournalCreatorViewModel
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack {
            TopProgressBarView
            switch viewModel.currentStep {
            case .shoot: SelectShootTypeView(viewModel: viewModel)
            case .emotion: EmotionInputView()
            case .review: ReviewPlanView()
            }
        }
    }
    
    private var TopProgressBarView: some View {
        HStack {
            Spacer()
            Button {
                // TODO: ViewModel에서 데이터 유무에 따른 분기처리 필요
                manager.fullScreenMode = nil
            } label: {
                Image(systemName: Constants.ImageStrings.xMark)
                    .font(.system(size: 20, weight: .semibold))
                    .tint(.black)
                    .padding()
            }
            // MARK: 13. Alert 만들기
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
