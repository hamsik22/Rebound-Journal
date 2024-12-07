//
//  JournalEntryCreatorView.swift
//  Rebound Journal
//
//  Created by hyunho lee on 2023/06/10.
//

import SwiftUI

enum EntryCreationStep: CaseIterable, Identifiable {
    case mood, today , shoot, images
    var id: Int { hashValue }
    
    var question: String {
        switch self {
        case .mood: return Constants.Strings.feelToday
        case .today: return Constants.Strings.todayShoot
        case .shoot: return Constants.Strings.howToRebound
        case .images: return Constants.Strings.attachPhotos
        }
    }
    
    var reboundQuestion: String {
        switch self {
        case .mood: return Constants.Strings.reboundFeelToday
        case .today: return Constants.Strings.reboundTodayShoot
        case .shoot: return Constants.Strings.reboundHowToRebound
        case .images: return Constants.Strings.reboundAttachPhotos
        }
    }
    
    var process: Int {
        switch self {
        case .mood: return 1
        case .today: return 2
        case .shoot: return 3
        case .images: return 4
        }
    }
}

struct JournalEntryCreatorView: View {
    
    @EnvironmentObject var manager: DataManager
    @Environment(\.colorScheme) var colorScheme
    @State private var showPhotoPicker: Bool = false
    @State private var selectedPhotoIndex: Int?
    @State private var showDoneButton: Bool = false
    @State private var currentStep: EntryCreationStep = .mood
    @State private var text: String = ""
    @State private var moodLevel: MoodLevel?
    @State private var todayText: String = ""
    @State private var reboundText: String = ""
    @State var isRebounded: Bool = false
    @State private var reasons: [MoodReason] = [MoodReason]()
    @State private var images: [UIImage] = [UIImage]()
    @State private var showAlert: Bool = false
    
    var body: some View {
        ZStack {
            Color(.diarySecondary).ignoresSafeArea()
            VStack {
                TopProgressBarView
                // MARK: 11. 조건에 따라서 화면이 바뀌도록하는 방법
                switch currentStep {
                case .mood: MoodLevelSelectorView
                case .today: EntryTextInputView
                case .shoot: ReboundTextInputView
                case .images: PhotosContainerView
                }
            }
        }
        // MARK: 12. 키보드 보이고 감추는 노티를 주는 방법
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIApplication.keyboardWillShowNotification, object: nil, queue: nil) { _ in
                DispatchQueue.main.async {
                    showDoneButton = true
                }
            }
            NotificationCenter.default.addObserver(forName: UIApplication.keyboardWillHideNotification, object: nil, queue: nil) { _ in
                DispatchQueue.main.async {
                    showDoneButton = false
                }
            }
        }
        /// Full modal screen flow
        .fullScreenCover(isPresented: $showPhotoPicker) {
            PhotoPicker { image in handleSelectedPhoto(image) }
        }
    }
    
    /// Handle selected photo
    private func handleSelectedPhoto(_ photo: UIImage?) {
        guard let image = photo, let currentIndex = selectedPhotoIndex else { return }
        if images.count > currentIndex {
            images[currentIndex] = image
        } else {
            images.append(image)
        }
    }
    
    private var TopProgressBarView: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack {
                Spacer()
                Button {
                    if !text.isEmpty || moodLevel != nil || images.count > 0 {
                        showAlert.toggle()
                    } else {
                        manager.fullScreenMode = nil
                    }
                } label: {
                    Image(systemName: Constants.ImageStrings.xMark)
                        .font(.system(size: 20, weight: .semibold))
                }
                // MARK: 13. Alert 만들기
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(Constants.Strings.exitFlow),
                          message: Text(Constants.Strings.exitDescription),
                          primaryButton: .default(Text("OK"), action: {
                        manager.fullScreenMode = nil
                    }),
                          secondaryButton: .cancel(Text("Cancel"))
                    )
                }
            }
            // progress bar
            HStack(spacing: 10) {
                ForEach(EntryCreationStep.allCases) { step in
                    Capsule()
                        .frame(height: 26)
                        .opacity(step.process <= currentStep.process ? 1 : 0.2)
                        .onTapGesture {
                            if step.process < currentStep.process {
                                currentStep = step
                            }
                        }
                        .foregroundStyle(.diaryBackground)
                }
            }
            Text(isRebounded ? currentStep.reboundQuestion : currentStep.question)
                .multilineTextAlignment(.leading)
                .font(.system(size: 28, weight: .semibold))
        }
        .foregroundColor(.text)
        .padding(.horizontal)
    }
    
    /// Next button
    private func NextButtonView(disabled: Bool) -> some View {
        Button {
            if currentStep == .images {
                if let level = moodLevel, !todayText.isEmpty, !reboundText.isEmpty, !text.isEmpty {
                    manager.saveEntry(text: text, moodLevel: level.rawValue, moodText: todayText, reboundText: reboundText, reasons: reasons, images: images)
                    if isRebounded {
                        manager.updateSelectedEntry(with: manager.seledtedEntry!)
                    }
                    manager.fullScreenMode = nil
                } else {
                    presentAlert(title: "Missing Fields", message: "Make sure that you've complete all required fields")
                }
            } else {
                if let index = EntryCreationStep.allCases.firstIndex(of: currentStep) {
                    currentStep = EntryCreationStep.allCases[index+1]
                }
            }
        } label: {
            ZStack {
                Color(.tabBar)
                    .cornerRadius(30).opacity(disabled ? 0.5 : 1)
                Text(currentStep == .images ? Constants.Strings.submitEntry : Constants.Strings.nextStep)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.diarySecondary)
            }
        }.frame(height: 60).disabled(disabled)
    }
    
    private var MoodLevelSelectorView: some View {
        VStack(spacing: 20) {
            HStack {
                ForEach(MoodLevel.allCases) { level in
                    VStack {
                        
                        Image("\(level)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .opacity(moodLevel == level ? 1 : 0.3)
                            .onTapGesture {
                                moodLevel = level
                            }
                        switch level {
                        case .level1:
                            Text("골인")
                        case .level2:
                            Text("리바운드")
                        }
                        
                    }
                }.frame(maxWidth: .infinity)
            }
            
            ZStack {
                Color.diaryPrimary.cornerRadius(20).opacity(colorScheme == .dark ? 1 : 0.1)
                if let mood = moodLevel {
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(mood.moodOptions, id: \.self) { myMood in
                            HStack {
                                Text(myMood)
                                Spacer()
                                Image(systemName: todayText == myMood ? "circle.fill" : "circle")
                                    .font(.system(size: 20))
                            }
                            .padding().background(.list)
                            .opacity(todayText == myMood ? 0.5 : 1)
                            .contentShape(Rectangle()).onTapGesture {
                                todayText = myMood
                            }
                        }.cornerRadius(10).padding()
                    }
                }
            }
            NextButtonView(disabled: moodLevel == nil || todayText.isEmpty)
        }.padding(.horizontal)
    }
    
    private var MoodReasonsListView: some View {
        VStack(spacing: 20) {
            ZStack {
                Color.diaryPrimary.cornerRadius(20)
                    .opacity(colorScheme == .dark ? 1 : 0.1)
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(MoodReason.allCases) { reason in
                        HStack {
                            Image("\(reason)")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18, alignment: .center)
                            Text(reason.rawValue.capitalized)
                            Spacer()
                            Image(systemName: reasons.contains(reason) ? "checkmark.square.fill" : "square").font(.system(size: 20))
                        }
                        .padding().background(.list)
                        .opacity(reasons.contains(reason) ? 0.5 : 1)
                        .contentShape(Rectangle()).onTapGesture {
                            if reasons.contains(reason) {
                                reasons.removeAll(where: { $0 == reason })
                            } else {
                                reasons.append(reason)
                            }
                        }
                    }.cornerRadius(10).padding()
                }
            }
            NextButtonView(disabled: reasons.count == 0)
        }.padding(.horizontal)
    }
    
    private var EntryTextInputView: some View {
        VStack(spacing: 20) {
            ZStack {
                Color.diaryPrimary
                    .cornerRadius(20)
                    .opacity(colorScheme == .dark ? 1 : 0.1)
                TextEditorView
                    .scrollContentBackground(.hidden)
            }
            
            if showDoneButton {
                if text.trimmingCharacters(in: .whitespaces).isEmpty {
                    Color.clear.frame(height: 1)
                } else {
                    Button {
                        hideKeyboard()
                    } label: {
                        Text(Constants.Strings.doneEditing)
                            .font(.system(size: 20, weight: .medium))
                    }
                    .padding(.bottom)
                    .foregroundColor(.text)
                    
                }
            } else {
                NextButtonView(disabled: text.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }.padding(.horizontal)
    }
    
    private var ReboundTextInputView: some View {
        VStack(spacing: 20) {
            ZStack {
                Color.diaryPrimary.cornerRadius(20)
                    .opacity(colorScheme == .dark ? 1 : 0.1)
                ReboundTextEditorView.scrollContentBackground(.hidden)
            }
            if showDoneButton{
                NextButtonView(disabled: reboundText.trimmingCharacters(in: .whitespaces).isEmpty)
            } else {
                if reboundText.trimmingCharacters(in: .whitespaces).isEmpty {
                    Color.clear.frame(height: 1)
                } else {
                    Button { hideKeyboard() } label: {
                        Text(Constants.Strings.doneEditing)
                            .font(.system(size: 20, weight: .medium))
                    }
                    .padding(.bottom)
                    .foregroundColor(.diaryBackground)
                }
            }
        }.padding(.horizontal)
    }
    
    private var TextEditorView: some View {
        TextEditor(text: $text)
            .padding(.leading, -5)
            .overlay(
                VStack {
                    HStack {
                        Text(Constants.Strings.describeShoot)
                        Spacer()
                    }
                    .opacity(text.isEmpty ? 0.5 : 0)
                    .allowsHitTesting(false)
                    Spacer()
                }.padding(.top, 7)
            )
            .padding(.top, 10)
            .foregroundColor(.text)
            .padding(.horizontal, 20)
    }
    
    private var ReboundTextEditorView: some View {
        TextEditor(text: $reboundText)
            .padding(.leading, -5)
            .overlay(
                VStack {
                    HStack {
                        Text(Constants.Strings.whatWillNext)
                        Spacer()
                    }
                    .opacity(reboundText.isEmpty ? 0.5 : 0)
                    .allowsHitTesting(false)
                    Spacer()
                }.padding(.top, 7)
            )
            .padding(.top, 10)
            .foregroundColor(.text)
            .padding(.horizontal, 20)
    }
    
    // MARK: - Photos container view
    private var PhotosContainerView: some View {
        let width = UIScreen.main.bounds.width-35
        func presentPhotoPickerAlert(_ index: Int) {
            selectedPhotoIndex = index
            showPhotoPicker = true
        }
        let placeholder = UIImage(named: "image-placeholder")!
        return VStack(spacing: 20) {
            ZStack {
                if images.count == 0 {
                    PhotoContainer(image: placeholder, index: 0, width: width, height: width)
                } else if images.count == 1 {
                    HStack(spacing: 5) {
                        PhotoContainer(image: images[0], index: 0, width: width/2-5, height: width/2-5)
                        PhotoContainer(image: placeholder, index: 1, width: width/2-5, height: width/2-5)
                    }
                } else if images.count == 2 {
                    HStack(spacing: 5) {
                        VStack(spacing: 5) {
                            PhotoContainer(image: images[0], index: 0, width: width/2-5, height: width/2-5)
                            PhotoContainer(image: images[1], index: 1, width: width/2-5, height: width/2-5)
                        }
                        PhotoContainer(image: placeholder, index: 2, width: width/2-5, height: width-2.5)
                    }
                } else if images.count == 3 || images.count == 4 {
                    HStack(spacing: 5) {
                        VStack(spacing: 5) {
                            PhotoContainer(image: images[0], index: 0, width: width/2-5, height: width/2-5)
                            PhotoContainer(image: images[1], index: 1, width: width/2-5, height: width/2-5)
                        }
                        if images.count == 3 {
                            VStack(spacing: 5) {
                                PhotoContainer(image: images[2], index: 2, width: width/2-5, height: width/2-5)
                                PhotoContainer(image: placeholder, index: 3, width: width/2-5, height: width/2-5)
                            }
                        } else {
                            VStack(spacing: 5) {
                                PhotoContainer(image: images[2], index: 2, width: width/2-5, height: width/2-5)
                                PhotoContainer(image: images[3], index: 3, width: width/2-5, height: width/2-5)
                            }
                        }
                    }
                }
            }.cornerRadius(20)
            Spacer()
            NextButtonView(disabled: false)
        }.padding(.horizontal)
    }
    
    /// Photo container view
    private func PhotoContainer(image: UIImage, index: Int, width: CGFloat, height: CGFloat) -> some View {
        func presentPhotoPickerAlert(_ index: Int) {
            selectedPhotoIndex = index
            showPhotoPicker = true
        }
        return Image(uiImage: image.resizeImage(newWidth: width)).resizable().aspectRatio(contentMode: .fill)
            .frame(width: width, height: height, alignment: .center).clipped()
            .contentShape(Rectangle()).onTapGesture { presentPhotoPickerAlert(index) }
    }
}

#Preview {
    JournalEntryCreatorView()
        .environmentObject(DataManager(preview: true))
        .preferredColorScheme(.dark)
}
