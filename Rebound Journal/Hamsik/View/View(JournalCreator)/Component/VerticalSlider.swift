//
//  VerticalSlider.swift
//  Rebound Journal
//
//  Created by 황석현 on 3/23/25.
//

import SwiftUI

struct VerticalSlider: View {
    @Binding var sliderValue: Double
    @Binding var isEdited: Bool
    
    var body: some View {
        VStack {
            Text("부정")
            ZStack {
                Color.clear
                    .frame(width: 20) // 원하는 크기의 컨테이너
                    .frame(maxHeight: .infinity)
                    .overlay(
                        Slider(value: $sliderValue, in: 0...3, step: 1) { editing in
                            isEdited = editing
                        }
                            .rotationEffect(.degrees(-90))
                            .frame(width: 400, height: 30)) // 원래 크기 유지
                    .onChange(of: sliderValue, perform: {
                        newValue in
                        print(newValue)
                    })
            }
            Text("긍정")
        }
        .padding(10)
    }
}

#Preview {
    VerticalSlider(sliderValue: .constant(1), isEdited: .constant(false))
}

