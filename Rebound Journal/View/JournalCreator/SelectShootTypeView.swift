//
//  SelectShootTypeView.swift
//  Rebound Journal
//
//  Created by 황석현 on 3/19/25.
//

import SwiftUI

struct SelectShootTypeView: View {
    // Shared Dependencies
    @ObservedObject var viewModel: JournalCreatorViewModel
    // UI State
    var isTypeSelected: Bool {viewModel.goalType == nil ? true : false}
    @Binding var currentStep: ReboundProcessStep
    // etc
    var text = Constants.ContentText()
    
    var body: some View {
        VStack {
            ShootCreationHeader(title: text.shootTypeTitle,
                                description: text.shootTypeDescription)
            Spacer()
            HStack {
								// 골인 버튼
                Button(action: {
                    toggleSelection(type: true)
                }) {
                    ShootTypeButton(type: true)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 160)
												.background(
														RoundedRectangle(cornerRadius: 10)
																.fill(Color.white)
																.shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 4)
												)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
																.stroke(viewModel.goalType == true ? Color.accentColor : .shootTypeButtonBorder, lineWidth: 1)
                        )
                }
                Spacer(minLength: 30)

								// 리바운드 버튼
                Button(action: {
                    toggleSelection(type: false)
                }) {
                    ShootTypeButton(type: false)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 160)
												.background(
														RoundedRectangle(cornerRadius: 10)
																.fill(Color.white)
																.shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 4)
												)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(viewModel.goalType == false ? Color.accentColor : Color.shootTypeButtonBorder, lineWidth: 1)
                        )
                }
            }
            Spacer()
            Button(action: {
								debugPrint("다음 화면으로 이동")
                currentStep = .emotion
            }) {
								if viewModel.goalType == nil {
										Text("다음으로")
												.font(.system(size: 18, weight: .bold))
												.padding()
												.frame(maxWidth: .infinity)
												.background(.disabledButtonBackground)
												.foregroundColor(.disabledButtonText)
												.cornerRadius(90)
												.disabled(true)
								} else {
										Text("다음으로")
												.font(.system(size: 18, weight: .bold))
												.padding()
												.frame(maxWidth: .infinity)
												.background(Color.accentColor)
												.foregroundColor(.white)
												.cornerRadius(90)
								}
            }
            .animation(.easeInOut, value: viewModel.goalType)
        }
        .padding()
    }
}

extension SelectShootTypeView {
    
    // 타입 비활성화를 위한 함수
    private func toggleSelection(type: Bool?) {
        if viewModel.goalType == type {
            viewModel.goalType = nil // 같은 버튼을 다시 누르면 선택 해제
        } else {
            viewModel.goalType = type // 선택된 타입 변경
        }
    }
    
    private func ShootTypeButton(type: Bool) -> some View {
        switch type {
        case true :
            VStack {
                Spacer()
                Image(.goalIn)
                    .resizable()
										.aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 70)
                Spacer()
                Text("골인")
                    .foregroundStyle(.default)
            }
        case false :
            VStack {
                Spacer()
                Image(.rebound)
                    .resizable()
										.aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 70)
                Spacer()
                Text("리바운드")
                    .foregroundStyle(.default)
            }
        }
    }
}

#Preview("SelectShootTypeView") {
    SelectShootTypeView(viewModel: JournalCreatorViewModel(), currentStep: .constant(.selectSubGoal))
}
