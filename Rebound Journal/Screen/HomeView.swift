//
//  HomeView.swift
//  Rebound Journal
//
//  Created by hyunho lee on 2023/06/10.
//

import SwiftUI

/// Main home tab for the app
struct HomeView: View {
    
    @EnvironmentObject var manager: DataManager
    @FetchRequest(sortDescriptors: []) private var results: FetchedResults<JournalEntry>
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            RoundedCorner(radius: 30, corners: [.topLeft, .topRight])
                .foregroundStyle(.list)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                let entries = checkReboundList()
                if  entries.count > 0 {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack {
                            CheckInBannerView
                                .padding(.top, 20)
                            ForEach(entries.sorted(by: { $0.date ?? Date() > $1.date ?? Date() })) { entry in
                                JournalEntryItem(model: entry)
                                    .onTapGesture {
                                        manager.fullScreenMode = .readJournalView
                                        manager.seledtedEntry = entry
                                    }
                            }
                        }
                        Spacer(minLength: 100)
                    }
                } else {
                    CheckInBannerView
                        .padding(.top, 20)
                    EmptyListView
                }
            }
        }.padding(.top, 10)
    }
    
    private func checkReboundList() -> [FetchedResults<JournalEntry>.Element] {
        let isTodaySelected = Date().longFormat == manager.selectedDate.longFormat
        print(isTodaySelected)
        
        if isTodaySelected { // 선택된 날이 오늘이면
            let nonReboundedNonDeleted = results.filter({ $0.isRebounded == false && $0.hasDeleted == false && $0.moodLevel == 2 })
            let matchingDate = results.filter({ $0.date?.longFormat == manager.selectedDate.longFormat })
            let combinedResults = Array(Set(nonReboundedNonDeleted + matchingDate))
            return combinedResults
        } else {
            return results.filter({ $0.date?.longFormat == manager.selectedDate.longFormat && $0.hasDeleted == false })
        }
    }
    
    /// Check-in banner view
    private var CheckInBannerView: some View {
        let disableCheckIn = Date().longFormat != manager.selectedDate.longFormat
        let isPastDate = Date() > manager.selectedDate
        return ZStack {
            Color(.diaryBackground)
                .cornerRadius(16)
            HStack {
                VStack(alignment: .leading) {
                    Text(disableCheckIn ? Constants.Strings.oops : Constants.Strings.reboundShootIn)
                        .font(.system(size: 20, weight: .semibold))
                    Text(disableCheckIn ? "\(isPastDate ? Constants.Strings.past : Constants.Strings.future) \(Constants.Strings.shootInIsDisabled)" : "\(Constants.Strings.howIsYourDaySoFar)")
                }
                .foregroundColor(.light)
                
                
                Spacer()
                
                Button {
                    manager.fullScreenMode = .entryCreator
                } label: {
                    ZStack {
                        Color.light
                            .cornerRadius(10)
                        Text(Constants.Strings.shootIn)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.diaryBackground)
                    }
                }
                .frame(width: 88, height: 42)
                .disabled(disableCheckIn)
            }.padding()
        }
        .frame(height: 72)
        .padding([.horizontal, .bottom])
        .opacity(disableCheckIn ? 0.8 : 1)
    }
    
    /// Journal entry item
    private func JournalEntryItem(model: JournalEntry) -> some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                JournalEntryHeaderView(model: model)
                if let entryText = model.text {
                    Text(entryText)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.text)
                }
                
                Color.dark.frame(height: 1).opacity(0.5)
                
                if let entryText = model.reboundText {
                    Text(entryText)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 20, weight: .regular))
                        .padding(.bottom, 10)
                        .foregroundColor(.text)
                }
                
                if let entryText = model.date?.longFormat {
                    Text(entryText)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 20, weight: .regular))
                        .padding(.bottom, 10)
                        .foregroundColor(.text)
                }
            }
            .padding([.top, .horizontal])
            
            JournaEntryPhotosView(model: model)
            // divider
            Color.dark
                .frame(height: 1)
                .padding(.horizontal)
                .opacity(0.5)
            JournaEntryFooterView(model: model)
        }
        .background(
            Color.list.cornerRadius(16)
                .shadow(color: Color.black.opacity(0.1), radius: 10)
        )
        .overlay(RoundedRectangle(cornerRadius: 16)
            .stroke(.dark, lineWidth: 1))
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
    
    private func JournalEntryHeaderView(model: JournalEntry) -> some View {
        HStack(alignment: .top) {
            Image("level\(model.moodLevel)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50, alignment: .center)
            VStack(alignment: .leading, spacing: 0) {
                Text(Constants.Strings.myMood)
                    .font(.system(size: 16, weight: .light))
                if let mood = model.moodText?.uppercased() {
                    Text(mood)
                        .font(.system(size: 20, weight: .bold))
                }
            }
            Spacer()
            // MARK: 리바운드 해줘!
            if model.moodLevel == 2 {
                Spacer()
                Button {
                    manager.fullScreenMode = .reboundCreator
                    manager.seledtedEntry = model
                } label: {
                    ZStack {
                        Color.diaryBackground
                            .cornerRadius(10)
                        Text(Constants.Strings.reShootIn)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.light)
                    }
                }
                .disabled(model.isRebounded)
                .opacity(model.isRebounded ? 0.3 : 1)
                .frame(width: 88, height: 42)
                
            }
            
        }
        .foregroundColor(.text)
    }
    
    /// Photos grid for a journal entry
    private func JournaEntryPhotosView(model: JournalEntry) -> some View {
        let width = UIScreen.main.bounds.width-60
        return ZStack {
            if let modelId = model.id,
                let images = manager.loadImages(id: modelId),
                images.count > 0 {
                ZStack {
                    if images.count == 1 {
                        EntryImage(images[0], width: width, height: width/2)
                    } else if images.count == 2 {
                        HStack(spacing: 5) {
                            EntryImage(images[0], width: width/2-5, height: width/2)
                            EntryImage(images[1], width: width/2-5, height: width/2)
                        }
                    } else if images.count == 3 || images.count == 4 {
                        HStack(spacing: 5) {
                            VStack(spacing: 5) {
                                EntryImage(images[0], width: width/2-5, height: width/2-5)
                                EntryImage(images[1], width: width/2-5, height: width/2-5)
                            }
                            if images.count == 3 {
                                EntryImage(images[2], width: width/2-5, height: width-5)
                            } else {
                                VStack(spacing: 5) {
                                    EntryImage(images[2], width: width/2-5, height: width/2-5)
                                    EntryImage(images[3], width: width/2-5, height: width/2-5)
                                }
                            }
                        }
                    }
                }.cornerRadius(16).padding(.bottom, 10)
            }
        }
    }
    
    private func EntryImage(_ image: UIImage, width: CGFloat, height: CGFloat) -> some View {
        Image(uiImage: image).resizable().aspectRatio(contentMode: .fill)
            .frame(width: width, height: height, alignment: .center).clipped()
            .onTapGesture {
                if let imageName = image.accessibilityIdentifier?.replacingOccurrences(of: "-thumbnail", with: "") {
                    manager.selectedEntryImage = manager.loadImage(id: imageName)
                }
            }
    }
    
    /// Footer view with a horizontal carousel showing mood reasons like work/travel/friends
    private func JournaEntryFooterView(model: JournalEntry) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                Spacer(minLength: 0)
                Spacer(minLength: 0)
            }
        }.padding(.bottom, 10).opacity(0.7)
    }
    
    /// Empty view
    private var EmptyListView: some View {
        VStack {
            Spacer()
            Image(systemName: "list.star")
                .font(.largeTitle)
                .padding(2)
            Text(Constants.Strings.noEntriesYet)
                .font(.title3)
                .bold()
            Text(Constants.Strings.noEntriesYetDiscription)
                .font(.subheadline)
                .opacity(0.6)
            Spacer()
            Spacer()
        }
        .multilineTextAlignment(.center)
        .foregroundColor(.text)
    }
}

// MARK: - Preview UI
struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(DataManager(preview: true))
    }
}
