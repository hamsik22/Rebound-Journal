//
//  VerticalSlider.swift
//  Rebound Journal
//
//  Created by 황석현 on 3/23/25.
//

import SwiftUI

struct VerticalSlider: View {
    // UI State
    @Binding var sliderValue: Double
    @Binding var isEdited: Bool
    
    var body: some View {
        VStack {
            Text("부정")
                .padding(.bottom, 16)
            
            GeometryReader { geometry in
                let height = geometry.size.height
                ZStack {
                    Color.clear
                        .frame(width: 35)
                        .frame(maxHeight: height)
                        .overlay(
                            Slider(value: $sliderValue, in: 0...3) { editing in
                                isEdited = editing
                                if !editing {
                                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            isEdited = editing
                                            sliderValue = round(sliderValue) // 가장 가까운 값으로 스냅
                                        }
                                    }
                                }
                            }
                                .rotationEffect(.degrees(-90))
                                .frame(width: height, height: 30))
                }
                .onChange(of: sliderValue) {
                    _, newValue in
                    debugPrint(newValue)
                }
            }
            
            Text("긍정")
                .padding(.top, 16)
        }
        .padding(10)
    }
}

#Preview {
    VerticalSlider(sliderValue: .constant(1), isEdited: .constant(false))
}
