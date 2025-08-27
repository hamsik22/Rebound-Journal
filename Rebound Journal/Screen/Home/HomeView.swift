//
//  HomeView.swift
//  Rebound Journal
//
//  Created by 황석현 on 8/19/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                topView(geometry)
                bottomView(geometry)
            }
        }
    }
    
    @ViewBuilder
    private func topView(_ geometry: GeometryProxy) -> some View {
        ZStack {
            Image(.homeTop)
                .resizable()
                .ignoresSafeArea()
                .frame(height: geometry.size.height * 0.3)
            VStack {
                topTrailingButton
                TargetList()
            }
        }
    }
    
    @ViewBuilder
    private func bottomView(_ geometry: GeometryProxy) -> some View {
        ZStack {
            Image(.homeBottom)
                .resizable()
                .ignoresSafeArea()
                .frame(height: geometry.size.height * 0.7)
            
            VStack(spacing: 0) {
                bottomHeader
                JournalList()
            }
            
            VStack {
                Spacer()
                bottomButton
            }
            
        }
    }
    
    
    
    private var bottomHeader: some View {
        HStack {
            Text("다시 리바운드-!")
                .font(.system(size: 22, weight: .semibold))
                .padding(.horizontal)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.accent)
        }
        .padding(.top, 20)
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
    private var bottomButton: some View {
        VStack {
            Spacer()
            Button {
                print("슛-쏘기 클릭")
            } label: {
                Text("슛-쏘기")
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .bold()
                    .background(.tint)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 90))
                    .padding(.horizontal)
                // SE 대응 패딩
                    .padding(.bottom, UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.height < 700 ? 16 : 0)
            }
        }
    }
    
}

#Preview {
    HomeView()
}

