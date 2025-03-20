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
                Button {
                    debugPrint("골인")
                    goalType = true
                } label: {
                    Text("골인")
                        .frame(width: 150, height: 150)
                        .background(isTypeSelected ? Color.gray : Color.green)
                }
                Button {
                    debugPrint("리바운드")
                    goalType = false
                } label: {
                    Text("리바운드")
                        .frame(width: 150, height: 150)
                        .background(isTypeSelected ? Color.gray : Color.green)
                }
            }
            Spacer()
            Button {
                debugPrint("다음으로")
            } label: {
                Text("다음으로")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
            }
        .disabled(isTypeSelected)
        }
        .padding()
    }
}

#Preview("SelectShootTypeView") {
    SelectShootTypeView()
}
