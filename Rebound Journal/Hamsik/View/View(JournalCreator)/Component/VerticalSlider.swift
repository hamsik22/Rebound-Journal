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
            ZStack {
                Color.clear
                    .frame(width: 20)
                    .frame(maxHeight: .infinity)
                    .overlay(
                        Slider(value: $sliderValue, in: 0...3, step: 1) { editing in
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    isEdited = editing
                                }
                            }
                        }
                            .rotationEffect(.degrees(-90))
                            .frame(width: 350, height: 30))
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

