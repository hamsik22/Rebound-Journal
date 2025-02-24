//
//  TargetList.swift
//  Rebound Journal
//
//  Created by 황석현 on 2/19/25.
//

import SwiftUI

struct TargetModel: Identifiable {
    let id: UUID = UUID()
    let type: String
    let title: String
    let count: Int
}
// TODO: 데이터 연동 필요
struct TargetList: View {
    
    var content: [TargetModel] = [TargetModel(type: "목표", title: "공부하기", count: 3),
                                  TargetModel(type: "목표", title: "운동하기", count: 4),
                                  TargetModel(type: "목표", title: "개발하기", count: 5)]
    var headerTitle: String?
    
    var body: some View {
        ZStack {
            VStack {
                // MARK: Header
                if let title = headerTitle {
                    HStack {
                        Text(title)
                        Spacer()
                    }
                }
                
                // MARK: Content
                List {
                    ForEach(content) { content in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(content.type)
                                Text(content.title)
                            }
                            .frame(maxWidth: .infinity,alignment: .leading)
                            Spacer()
                            Button {
                                
                            } label: {
                                Text("기록하기")
                                    .font(.system(size: 13))
                                    .frame(width: 65, height: 24)
                                    .foregroundStyle(.black)
                                    .background(Color.gray.opacity(0.5))
                                    .clipShape(.rect(cornerRadius: 8))
                            }
                            
                            Text("\(content.count)회")
                            Button {
                                print("\(content.title) 상세보기")
                            } label: {
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.black)
                            }
                            
                        }
                        .frame(height: 40)
                        .listRowBackground(Color(.diarySecondary))
                    }
                }
                .listStyle(.inset)
                .scrollContentBackground(.hidden)
            }
        }
    }
}

#Preview {
    TargetList(content: [TargetModel(type: "목표", title: "공부하기", count: 5),
                         TargetModel(type: "목표", title: "공부하기", count: 5)
                        ], headerTitle: "목표")
}
