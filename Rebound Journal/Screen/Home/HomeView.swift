//
//  HomeView.swift
//  Rebound Journal
//
//  Created by 황석현 on 8/19/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Query private var journals: [JournalData]
    @Query private var subGoals: [SubGoalData]
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // MARK: Top
                ZStack {
                    Image(.homeUpper)
                        .resizable()
                        .ignoresSafeArea()
                        .frame(height: geometry.size.height * 0.3)
                    VStack {
                        topTrailingButton
                        TargetList()
                    }
                }
                
                // MARK: Bottom
                ZStack {
                    Color.clear
                        .ignoresSafeArea()
                        .frame(height: geometry.size.height * 0.7)
                    
                    VStack {
                        bottomHeader
                        JournalList()
                    }
                    
                    VStack {
                        Spacer()
                        Button {
                            
                        } label: {
                            Text("슛-쏘기")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                }
            }
        }
    }
    
    private var bottomHeader: some View {
        HStack {
            Text("다시 리바운드-!")
                .font(.system(size: 22, weight: .semibold)) // 590 근사치
                .padding(.horizontal)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.accent)
        }
        .padding(.bottom)
    }
    
    private var topTrailingButton: some View {
        HStack {
            Spacer()
            Button {
                print("전체기록 보기")
            } label: {
                Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25)
                    .bold()
            }
            .tint(.black)
            
            Button {
                print("통계화면 보기")
            } label: {
                Image(systemName: "chart.bar.xaxis")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25)
            }
            .tint(.black)
            
            Button {
                print("설정화면 보기")
            } label: {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25)
            }
            .tint(.black)
        }
        .padding(.trailing)
    }
    
}

#Preview {
    HomeView()
}

