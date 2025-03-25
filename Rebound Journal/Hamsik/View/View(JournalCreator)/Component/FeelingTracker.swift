//
//  FeelingShape.swift
//  Rebound Journal
//
//  Created by 황석현 on 3/23/25.
//

import SwiftUI

struct FeelingTracker: View {
    
    @ObservedObject var viewModel: JournalCreatorViewModel
    
    @State var feelingShape: ImageResource = .positiveCircle
    @State var feelingValue: Double = 0.0
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
                        FeelingText()
                    }
                    else {
                        FeelingShape(value: $feelingValue,
                                     currentFeelingShape: $feelingShape)
                    }
                    Spacer()
                    VerticalSlider(sliderValue: $feelingValue, isEdited: $viewModel.isSliderEditing)
                        .onChange(of: feelingValue, perform: { newValue in
                            print("Slider: \(newValue)")
                            switch newValue {
                            case 0:
                                feelingShape = .positiveCircle
                            case 1:
                                feelingShape = .softSpikes
                            case 2:
                                feelingShape = .sharpSpike
                            case 3:
                                feelingShape = .thornball
                            default:
                                feelingShape = .softSpikes
                            }
                        })
                        .onChange(of: viewModel.isSliderEditing) { newValue in
                            viewModel.emotionValue = feelingValue
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
    FeelingTracker(viewModel: JournalCreatorViewModel())
}
