//
//  TodayShootHistory.swift
//  Rebound Journal
//
//  Created by 황석현 on 2/19/25.
//

import SwiftUI

struct ShootModel: Identifiable {
    let id = UUID()
    let title: String
    let date: String //임시
}
// TODO: 데이터 연동 필요
struct TodayShootHistory: View {
    
    var contents: [ShootModel] = [
        ShootModel(title: "살을 빼고 싶다", date: "12.17(화)"),
        ShootModel(title: "개발 잘하고 싶다", date: "12.18(수)"),
        ShootModel(title: "운동 잘하고 싶다", date: "12.19(목)")
    ]
    
    var body: some View {
        VStack {
            // MARK: Header
            HStack {
                Text("오늘 나의 슛")
                Spacer()
                Text("슛 전체")
                    .font(.system(size: 13))
                    .frame(width: 65, height: 24)
                    .foregroundStyle(.black)
                    .bold()
                    .background(Color.gray.opacity(0.5))
                    .clipShape(.rect(cornerRadius: 8))
            }
            // MARK: Content
            TabView {
                ForEach(contents) { item in
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("계획")
                                Text(item.title)
                            }
                            .frame(alignment: .leading)
                            Spacer()
                            Text(item.date)
                        }
                        Spacer()
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .frame(height: 100)
            .padding()
        }
    }
}

#Preview {
    TodayShootHistory()
}
