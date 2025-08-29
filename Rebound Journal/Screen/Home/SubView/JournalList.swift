//
//  JournalList.swift
//  Rebound Journal
//
//  Created by 황석현 on 8/19/25.
//

import SwiftUI
import SwiftData

struct DummyData: Identifiable, Hashable {
    let id = UUID()
    let target: String
    let type: Bool
    let journal: String
    let description: String
    let date: Date
}

struct JournalList: View {
    
    let dummys: [DummyData] = [
        DummyData(target: "6시 30분에 일어나기", type: false, journal: "내일은 알람을 10분 일찍 맞춰보자", description: "달리기를 하려고 했는데 늦잠을 자서 못했어.", date: Date().addingTimeInterval(-86400)),
        DummyData(target: "물 2리터 마시기", type: true, journal: "오늘은 회사에서도 물을 자주 마셨다", description: "건강해지는 느낌이 든다.", date: Date().addingTimeInterval(-2*86400)),
        DummyData(target: "하루 30분 책 읽기", type: false, journal: "내일부터는 자기 전에 꼭 10분이라도 읽자", description: "퇴근하고 너무 피곤해서 책을 못 읽었다.", date: Date().addingTimeInterval(-3*86400)),
        DummyData(target: "저녁 7시 이후 간식 금지", type: true, journal: "야식 생각났지만 참았다", description: "의지가 조금씩 강해지고 있다.", date: Date().addingTimeInterval(-4*86400)),
        DummyData(target: "아침 스트레칭 하기", type: false, journal: "알람 울리면 바로 매트 깔아야겠다", description: "늦게 일어나서 스트레칭을 놓쳤다.", date: Date().addingTimeInterval(-5*86400)),
        DummyData(target: "하루 1시간 코딩 공부", type: true, journal: "SwiftUI 레이아웃을 연습했다", description: "조금씩 감이 잡히고 있다.", date: Date().addingTimeInterval(-6*86400)),
        DummyData(target: "하루 10분 명상하기", type: false, journal: "내일부터는 아침에 명상해보자", description: "정신이 산만해서 명상 시간을 잊어버렸다.", date: Date().addingTimeInterval(-7*86400)),
        DummyData(target: "영어 단어 20개 외우기", type: true, journal: "오늘은 새로운 단어를 잘 기억했다", description: "조금씩 어휘력이 늘고 있다.", date: Date().addingTimeInterval(-8*86400)),
        DummyData(target: "저녁 운동하기", type: false, journal: "운동복을 미리 챙겨놔야겠다", description: "야근 때문에 운동을 못 갔다.", date: Date().addingTimeInterval(-9*86400)),
        DummyData(target: "일기 쓰기", type: true, journal: "오늘 하루를 정리하면서 마음이 편안해졌다", description: "꾸준히 이어가는 게 뿌듯하다.", date: Date().addingTimeInterval(-10*86400))
    ]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(dummys) { dummy in
                    targetInfo(target: dummy.target, type: dummy.type)
                    journalInfo(journal: dummy.journal, description: dummy.description, date: dummy.date)
                }
            }
            .padding()            
        }
    }
    
    private func targetInfo(target: String = "목표 제목", type: Bool = false) -> some View {
        HStack {
            Text("목표")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.accentColor)
                .multilineTextAlignment(.center)
            
            Text(target)
                .font(.system(size: 18, weight: .semibold))
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Text(type ? "골인" : "리바운드")
                .font(.custom("Pretendard", size: 13).weight(.semibold))
                .foregroundStyle(.accent)
                .multilineTextAlignment(.center)
                .padding(10)
                .frame(height: 26, alignment: .center)
                .background(Color(red: 1, green: 0.94, blue: 0.9))
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.25), radius: 3, x: 0, y: 1)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 8)
    }
    private func journalInfo(journal: String = "저널 제목", description: String = "느낀 점...", date: Date = Date()) -> some View {
        VStack(spacing: 8) {
            Text(journal)
                .font(.system(size: 20, weight: .semibold))
            // TODO: 색상 적용
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(description)
                .font(.system(size: 13, weight: .regular))
            // TODO: 색상 적용
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(date.description)
                .font(.system(size: 13, weight: .regular))
            // TODO: 색상 적용
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.cellColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    JournalList()
}

