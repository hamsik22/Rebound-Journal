//
//  SelectShootTypeView.swift
//  Rebound Journal
//
//  Created by 황석현 on 3/19/25.
//

import SwiftUI

struct SelectShootTypeView: View {
    
    @State var isGoalIn: Bool? = nil
    
    var title: String = Constants.Strings.shootTypeTitle
    var description: String = Constants.Strings.shootTypeDescription
    @State var goalType: Bool? = nil
    var isTypeSelected: Bool {
        goalType == nil ? true : false
    }
    
    var body: some View {
        VStack {
            ShootCreationHeader(title: title,
                                description: description)
            Spacer()
            HStack {
                Button(action: {
                    toggleSelection(type: true)
                    debugPrint("Type : \(goalType ?? true)")
                    debugPrint("골인")
                }) {
                    ShootTypeButton(type: true)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 160)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(goalType == true ? Color.accentColor : Color.gray, lineWidth: 2)
                        )
                }
                Spacer(minLength: 30)

                Button(action: {
                    toggleSelection(type: false)
                    debugPrint("Type : \(goalType ?? false)")
                    debugPrint("리바운드")
                }) {
                    ShootTypeButton(type: false)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 160)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(goalType == false ? Color.accentColor : Color.gray, lineWidth: 2)
                        )
                }
            }
            Spacer()
            Button(action: {
                print("다음 화면으로 이동")
            }) {
                Text("다음으로")
                    .font(.system(size: 18, weight: .bold))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(goalType != nil ? Color.accentColor : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(90)
            }
            .disabled(goalType == nil)
        }
        .padding()
    }
    private func toggleSelection(type: Bool?) {
        if goalType == type {
            goalType = nil // 같은 버튼을 다시 누르면 선택 해제
        } else {
            goalType = type // 선택된 타입 변경
        }
    }
    private func ShootTypeButton(type: Bool) -> some View {
        switch type {
        case true :
            VStack {
                Spacer()
                Image(.goalIn)
                    .resizable()
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
                    .frame(width: 60, height: 70)
                Spacer()
                Text("리바운드")
                    .foregroundStyle(.default)
            }
        }
    }
}

#Preview("SelectShootTypeView") {
    SelectShootTypeView()
}
