//
//  JournalEntryCreatorView.swift
//  Rebound Journal
//
//  Created by hyunho lee on 2023/06/10.
//

import SwiftUI

/// Journal Entry Creation steps
enum EntryCreationStep: CaseIterable, Identifiable {
    case text, shoot, rebound   //reasons,
    var id: Int { hashValue }
    
    /// Step question
    var question: String {
        switch self {
        case .text: return "What shot did you shoot today?"
        case .shoot: return "Hello, how do you feel today?"
        case .rebound: return "How can you rebound?"
        //case .reasons: return "What makes you feel this way?"
        }
    }
    
    var level: Int {
        switch self {
        case .text: return 1
        case .shoot: return 2
        case .rebound: return 3
        }
    }
}

struct JournalDetailView: View {
    @EnvironmentObject var manager: DataManager
    @State private var todayText: String = ""
    //@State private var reboundText: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Spacer()
                Button {
                    manager.fullScreenMode = nil
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .semibold))
                }
            }
            
            Image("level\(manager.seledtedEntry!.moodLevel)")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
            
            Text("What I shoot")
                .multilineTextAlignment(.leading)
                .font(.system(size: 28, weight: .semibold))
            HStack {
                Text(manager.seledtedEntry?.text ?? "empty")
                    .padding()
                Spacer()
            }
            .multilineTextAlignment(.leading)
            .background(Color("DarkColor"))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 10)
            
            Text("My rebound plan")
                .multilineTextAlignment(.leading)
                .font(.system(size: 28, weight: .semibold))
            HStack {
                
                Text(manager.seledtedEntry?.reboundText ?? "empty")
                    .padding()
                Spacer()
            }
            .multilineTextAlignment(.leading)
            .background(Color("DarkColor"))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 10)
            
            Spacer()
                
        }
        .padding()
    }
}

/// Journal entry creator flow
struct JournalEntryCreatorView: View {
    
    @EnvironmentObject var manager: DataManager
    @Environment(\.colorScheme) var colorScheme
    @State private var showPhotoPicker: Bool = false
    @State private var selectedPhotoIndex: Int?
    @State private var showDoneButton: Bool = false
    @State private var currentStep: EntryCreationStep = .text
    @State private var text: String = ""
    @State private var moodLevel: MoodLevel?
    @State private var todayText: String = ""
    @State private var reboundText: String = ""
    @State private var isRebounded: Bool = false
    @State private var reasons: [MoodReason] = [MoodReason]()
    @State private var images: [UIImage] = [UIImage]()
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Color("Secondary").ignoresSafeArea()
            VStack {
                TopProgressBarView
                switch currentStep {
                case .text: EntryTextInputView
                case .shoot: MoodLevelSelectorView
                //case .reasons: MoodReasonsListView
                case .rebound: ReboundTextInputView //PhotosContainerView
                }
            }
        }
        /// Register for keyboard events
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIApplication.keyboardWillShowNotification, object: nil, queue: nil) { _ in
                DispatchQueue.main.async {
                    self.showDoneButton = true
                }
            }
            NotificationCenter.default.addObserver(forName: UIApplication.keyboardWillHideNotification, object: nil, queue: nil) { _ in
                DispatchQueue.main.async {
                    self.showDoneButton = false
                }
            }
        }
        /// Full modal screen flow
        .fullScreenCover(isPresented: $showPhotoPicker) {
            PhotoPicker { image in handleSelectedPhoto(image) }
        }
    }
    
    /// Top progress bar view
    private var TopProgressBarView: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Spacer()
                Button {
                    if !text.isEmpty || moodLevel != nil || images.count > 0 {
                        presentAlert(title: "Exit Flow", message: "Are you sure you want to leave this flow? You will lose your current progress", primaryAction: .Cancel, secondaryAction: .init(title: "Exit", style: .destructive, handler: { _ in
                            manager.fullScreenMode = nil
                        }))
                    } else {
                        manager.fullScreenMode = nil
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .semibold))
                }
            }
            HStack(spacing: 10) {
                ForEach(EntryCreationStep.allCases) { step in
                    Capsule()
                        .frame(height: 26)
                        .opacity(step.level <= currentStep.level ? 1 : 0.2)
                        .onTapGesture {
                            if step.level < currentStep.level {
                                currentStep = step
                                print("??")
                            }
                        }
                }
            }
            Text(currentStep.question)
                .multilineTextAlignment(.leading)
                .font(.system(size: 28, weight: .semibold))
        }.foregroundColor(Color("TextColor")).padding(.horizontal)
    }
    
    /// Next button
    private func NextButtonView(disabled: Bool) -> some View {
        Button {
            if currentStep == .rebound {
                if let level = moodLevel, !todayText.isEmpty, !reboundText.isEmpty, //reasons.count > 0, !text.isEmpty {
                   !text.isEmpty {
                    manager.saveEntry(text: text, moodLevel: level.rawValue, moodText: todayText, reboundText: reboundText, reasons: reasons, images: images)
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
                Color("TabBarColor")
                    .cornerRadius(30).opacity(disabled ? 0.5 : 1)
                Text(currentStep == .rebound ? "Submit Entry" : "Next Step")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color("Secondary"))
            }
        }.frame(height: 60).disabled(disabled)
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
    
    // MARK: - Mood Level selector
    private var MoodLevelSelectorView: some View {
        VStack(spacing: 20) {
            HStack {
                ForEach(MoodLevel.allCases) { level in
                    Image("\(level)")
                        .opacity(moodLevel == level ? 1 : 0.3)
                        .onTapGesture {
                            moodLevel = level
                            if moodLevel == .level1 {
                                isRebounded = false
                            } else if moodLevel == .level2 {
                                isRebounded = true
                            }
                        }
                }.frame(maxWidth: .infinity)
            }
            ZStack {
                Color("Primary").cornerRadius(20)
                    .opacity(colorScheme == .dark ? 1 : 0.1)
                if let mood = moodLevel {
                    /// List of mood options
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(0..<mood.moodOptions.count, id: \.self) { index in
                            HStack {
                                Text(mood.moodOptions[index])
                                Spacer()
                                Image(systemName: todayText == mood.moodOptions[index] ? "circle.fill" : "circle")
                                    .font(.system(size: 20))
                            }
                            .padding().background(Color("ListColor"))
                            .opacity(todayText == mood.moodOptions[index] ? 0.5 : 1)
                            .contentShape(Rectangle()).onTapGesture {
                                todayText = mood.moodOptions[index]
                            }
                        }.cornerRadius(10).padding()
                    }
                }
            }
            NextButtonView(disabled: moodLevel == nil || todayText.isEmpty)
        }.padding(.horizontal)
    }
    
    // MARK: - Mood Reasons list
    private var MoodReasonsListView: some View {
        VStack(spacing: 20) {
            ZStack {
                Color("Primary").cornerRadius(20)
                    .opacity(colorScheme == .dark ? 1 : 0.1)
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(MoodReason.allCases) { reason in
                        HStack {
                            Image("\(reason)").resizable().aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18, alignment: .center)
                            Text(reason.rawValue.capitalized)
                            Spacer()
                            Image(systemName: reasons.contains(reason) ? "checkmark.square.fill" : "square").font(.system(size: 20))
                        }
                        .padding().background(Color("ListColor"))
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
    
    // MARK: - Entry TextView
    private var EntryTextInputView: some View {
        VStack(spacing: 20) {
            ZStack {
                Color("Primary").cornerRadius(20)
                    .opacity(colorScheme == .dark ? 1 : 0.1)
                if #available(iOS 16.0, *) {
                    TextEditorView.scrollContentBackground(.hidden)
                } else {
                    TextEditorView
                }
            }
            if showDoneButton == false {
                NextButtonView(disabled: text.trimmingCharacters(in: .whitespaces).isEmpty)
            } else {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty {
                    Button { hideKeyboard() } label: {
                        Text("Done Editing").font(.system(size: 20, weight: .medium))
                    }.padding(.bottom).foregroundColor(Color("TextColor"))
                } else {
                    Color.clear.frame(height: 1)
                }
            }
        }.padding(.horizontal)
    }
    
    private var ReboundTextInputView: some View {
        VStack(spacing: 20) {
            ZStack {
                Color("Primary").cornerRadius(20)
                    .opacity(colorScheme == .dark ? 1 : 0.1)
                if #available(iOS 16.0, *) {
                    ReboundTextEditorView.scrollContentBackground(.hidden)
                } else {
                    ReboundTextEditorView
                }
            }
            if showDoneButton == false {
                NextButtonView(disabled: reboundText.trimmingCharacters(in: .whitespaces).isEmpty)
            } else {
                if !reboundText.trimmingCharacters(in: .whitespaces).isEmpty {
                    Button { hideKeyboard() } label: {
                        Text("Done Editing").font(.system(size: 20, weight: .medium))
                    }.padding(.bottom).foregroundColor(Color("TextColor"))
                } else {
                    Color.clear.frame(height: 1)
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
                    Text("Describe how was your day so far...")
                    Spacer()
                }
                .opacity(text.isEmpty ? 0.5 : 0)
                .allowsHitTesting(false)
                Spacer()
            }.padding(.top, 7)
        )
        .padding(.top, 10)
        .foregroundColor(Color("TextColor"))
        .padding(.horizontal, 20)
    }
    
    private var ReboundTextEditorView: some View {
        TextEditor(text: $reboundText)
            .padding(.leading, -5)
            .overlay(
            VStack {
                HStack {
                    Text("Describe how was your day so far...")
                    Spacer()
                }
                .opacity(reboundText.isEmpty ? 0.5 : 0)
                .allowsHitTesting(false)
                Spacer()
            }.padding(.top, 7)
        )
        .padding(.top, 10)
        .foregroundColor(Color("TextColor"))
        .padding(.horizontal, 20)
    }
    
    // MARK: - Photos container view
    private var PhotosContainerView: some View {
        let width = UIScreen.main.bounds.width-35
        func presentPhotoPickerAlert(_ index: Int) {
            selectedPhotoIndex = index
            showPhotoPicker = true
//            if manager.isPremiumUser {
//                showPhotoPicker = true
//            } else {
//                presentAlert(title: "Premium Feature", message: "You must upgrade to the premium version if you want to add photos to your journal check-ins")
//            }
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
//            if manager.isPremiumUser {
//                showPhotoPicker = true
//            } else {
//                presentAlert(title: "Premium Feature", message: "You must upgrade to the premium version if you want to add photos to your journal check-ins")
//            }
        }
        return Image(uiImage: image.resizeImage(newWidth: width)).resizable().aspectRatio(contentMode: .fill)
            .frame(width: width, height: height, alignment: .center).clipped()
            .contentShape(Rectangle()).onTapGesture { presentPhotoPickerAlert(index) }
    }
}

// MARK: - Preview UI
struct JournalEntryCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        JournalEntryCreatorView()
            .environmentObject(DataManager(preview: true))
            .preferredColorScheme(.dark)
    }
}
