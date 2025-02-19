//
//  ReboundStatusBoard.swift
//  Rebound Journal
//
//  Created by 황석현 on 2/19/25.
//

import SwiftUI

struct ReboundStatusBoard: View {
    var body: some View {
        HStack {
            VStack {
                Text("이번 달 슛")
                    .font(.system(size: 13))
                Text("10개")
                    .font(.system(size: 18))
                    .bold()
            }
            .frame(maxWidth: .infinity)
            Divider()
            VStack {
                Text("전체 목표")
                    .font(.system(size: 13))
                Text("12개")
                    .font(.system(size: 18))
                    .bold()
            }
            .frame(maxWidth: .infinity)
            Divider()
            VStack {
                Text("전체 리바운드")
                    .font(.system(size: 13))
                Text("20개")
                    .font(.system(size: 18))
                    .bold()
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 55)
        .background(Color.gray)
        .clipShape(.rect(cornerRadius: 8))
        .padding(.bottom, 10)
    }
}

#Preview {
    ReboundStatusBoard()
}

