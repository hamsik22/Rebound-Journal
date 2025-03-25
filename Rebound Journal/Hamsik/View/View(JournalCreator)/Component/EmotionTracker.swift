//
//  FeelingShape.swift
//  Rebound Journal
//
//  Created by 황석현 on 3/23/25.
//

import SwiftUI

struct EmotionTracker: View {
    
    @ObservedObject var viewModel: JournalCreatorViewModel
    
    @State var emotionShape: ImageResource = .positiveCircle
    @State var emotionValue: Double = 0.0
    @State var emotionText: [String] = []
    var isFirstEnter: Bool {
        !viewModel.isSliderEditing && viewModel.emotionValue == nil
    }
    var isSliderEditing: Bool {
        viewModel.isSliderEditing
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 5) {
                    if isFirstEnter {
                        Text("슬라이더를 움직여\n감정을 표현해보세요")
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.description)
                            .bold()
                            .padding()
                    } else if !isSliderEditing {
                        EmotionText(selectedTags: $emotionText)
                            .onChange(of: emotionText) { newValue in
                                viewModel.emotionText = newValue
                            }
                    }
                    else {
                        FeelingShape(value: $emotionValue,
                                     currentFeelingShape: $emotionShape)
                    }
                    Spacer()
                    VerticalSlider(sliderValue: $emotionValue, isEdited: $viewModel.isSliderEditing)
                        .onChange(of: emotionValue, perform: { newValue in
                            print("Slider: \(newValue)")
                            switch newValue {
                            case 0:
                                emotionShape = .positiveCircle
                            case 1:
                                emotionShape = .softSpikes
                            case 2:
                                emotionShape = .sharpSpike
                            case 3:
                                emotionShape = .thornball
                            default:
                                emotionShape = .softSpikes
                            }
                        })
                        .onChange(of: viewModel.isSliderEditing) { newValue in
                            viewModel.emotionValue = emotionValue
                        }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct FeelingShape: View {
    @Binding var value: Double
    @State var scale = false
    @Binding var currentFeelingShape: ImageResource
    @State var shapeScale: CGFloat = 1
    
    var body: some View {
                Image(currentFeelingShape)
                    .resizable().scaledToFit()
                    .frame(maxWidth: .infinity)
                    .scaleEffect(shapeScale)
            .onChange(of: currentFeelingShape, perform: { _ in
                withAnimation {
                    shapeScale = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        shapeScale = 1
                    }
                }
            })
            
            .onAppear() {
                withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                    scale.toggle()
                }
            }
    }
}

#Preview {
    EmotionTracker(viewModel: JournalCreatorViewModel())
}
