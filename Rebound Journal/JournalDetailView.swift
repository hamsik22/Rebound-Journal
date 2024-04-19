//
//  JournalDetailView.swift
//  Rebound Journal
//
//  Created by Leeo on 4/19/24.
//

import SwiftUI

struct JournalDetailView: View {
    @EnvironmentObject var manager: DataManager
    @State private var todayText: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Spacer()
                Button {
                    // MARK: 11. Binding과 EnvironmentObject로 다른화면의 데이터 바꾸기
                    manager.fullScreenMode = nil
                } label: {
                    Image(systemName: Constants.ImageStrings.xMark)
                        .font(.system(size: 20,
                                      weight: .semibold))
                }
            }
            
            Image("level\(manager.seledtedEntry!.moodLevel)")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
            
            Text(Constants.Strings.whatIshoot)
                .multilineTextAlignment(.leading)
                .font(.system(size: 28, weight: .semibold))
            HStack {
                Text(manager.seledtedEntry?.text ?? "empty")
                    .padding()
                Spacer()
            }
            .multilineTextAlignment(.leading)
            .background(.list)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 10)
            
            Text(Constants.Strings.myReboundPlan)
                .multilineTextAlignment(.leading)
                .font(.system(size: 28, weight: .semibold))
            
            HStack {
                Text(manager.seledtedEntry?.reboundText ?? "empty")
                    .padding()
                Spacer()
            }
            .multilineTextAlignment(.leading)
            .background(.list)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 10)
            
            Spacer()
                
        }
        .padding()
    }
}

#Preview {
    JournalDetailView()
}
