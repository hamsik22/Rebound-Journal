//
//  JournalEntryCreatorView.swift
//  Rebound Journal
//
//  Created by hyunho lee on 2023/06/10.
//

import SwiftUI

enum EntryCreationStep: CaseIterable, Identifiable {
    case today, mood, shoot
    var id: Int { hashValue }
    
    var question: String {
        switch self {
        case .today: return Constants.Strings.todayShoot
        case .mood: return Constants.Strings.feelToday
        case .shoot: return Constants.Strings.howToRebound
        }
    }
    
    var reboundQuestion: String {
        switch self {
        case .today: return Constants.Strings.reboundTodayShoot
        case .mood: return Constants.Strings.reboundFeelToday
        case .shoot: return Constants.Strings.reboundHowToRebound
        }
    }
    
    var process: Int {
        switch self {
        case .today: return 1
        case .mood: return 2
        case .shoot: return 3
        }
    }
}

struct JournalEntryCreatorView: View {
    
    @EnvironmentObject var manager: DataManager
    @Environment(\.colorScheme) var colorScheme
    @State private var showPhotoPicker: Bool = false
    @State private var selectedPhotoIndex: Int?
    @State private var showDoneButton: Bool = false
    @State private var currentStep: EntryCreationStep = .today
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
                case .today: EntryTextInputView
                case .mood: MoodLevelSelectorView
                case .shoot: ReboundTextInputView
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
            if currentStep == .shoot {
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
                Text(currentStep == .shoot ? Constants.Strings.submitEntry : Constants.Strings.nextStep)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.diarySecondary)
            }
        }.frame(height: 60).disabled(disabled)
    }
    
    private var MoodLevelSelectorView: some View {
        VStack(spacing: 20) {
            HStack {
                ForEach(MoodLevel.allCases) { level in
                    Image("\(level)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .opacity(moodLevel == level ? 1 : 0.3)
                        .onTapGesture {
                            moodLevel = level
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
}

#Preview {
    JournalEntryCreatorView()
        .environmentObject(DataManager(preview: true))
        .preferredColorScheme(.dark)
}
