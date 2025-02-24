//
//  FeelAfterShootingView.swift
//  Rebound Journal
//
//  Created by 황석현 on 2/24/25.
//

import SwiftUI

struct FeelAfterShootingView: View {
    
    @State private var sliderValue: Double = 0
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text(Constants.Strings.goalMessage)
                    .font(.system(size: 18))
                    .padding(.leading, 16)
                Spacer()
            }
            HStack {
                Text(Constants.Strings.currentEmotion)
                    .font(.system(size: 22))
                    .bold()
                    .padding(.leading, 16)
                Spacer()
            }
            
            // Contents
            HStack {
                VerticalSliderView()
            }
        }
    }
}

struct VerticalSliderView: View {
    @State private var value: Double = 50
    
    var body: some View {
        VStack {
            Text("Value: \(Int(value))")
                .padding()
            
            Slider(value: $value, in: 0...100)
                .rotationEffect(.degrees(-90)) // 90도 회전시켜 세로로 만듦
                .frame(height: 300)
                .padding()
        }
    }
}

#Preview("FeelAfterShootingView") {
    FeelAfterShootingView()
}

