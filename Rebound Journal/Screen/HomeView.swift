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
                .foregroundStyle(Color("ListColor"))
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                var entries = results.filter({ $0.date?.longFormat == manager.selectedDate.longFormat })
                if  entries.count > 0 {
                    ScrollView(.vertical, showsIndicators: false) {
//                        Spacer(minLength: 6)
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
                    .onAppear {
                        //entries.append(contentsOf: results.filter({ $0.moodLevel == 2 }))
                        entries.append(contentsOf: results.filter({ $0.isRebounded == true }))
                    }
                } else {
                    CheckInBannerView
                        .padding(.top, 20)
                    EmptyListView
                }
            }
        }.padding(.top, 10)
    }
    
    /// Check-in banner view
    private var CheckInBannerView: some View {
        let disableCheckIn = Date().longFormat != manager.selectedDate.longFormat
        let isPastDate = Date() > manager.selectedDate
        return ZStack {
            Color("BackgroundColor")
                .cornerRadius(16)
            HStack {
                VStack(alignment: .leading) {
                    Text(disableCheckIn ? Constants.Strings.oops : Constants.Strings.reboundShootIn)
                        .font(.system(size: 20, weight: .semibold))
                    Text(disableCheckIn ? "\(isPastDate ? Constants.Strings.past : Constants.Strings.future) \(Constants.Strings.shootInIsDisabled)" : " \(Constants.Strings.howIsYourDaySoFar)")
                }
                .foregroundColor(Color("LightColor"))
                
                
                Spacer()
                
                Button {
                    manager.fullScreenMode = .entryCreator
                } label: {
                    ZStack {
                        Color("LightColor")
                            .cornerRadius(10)
                        Text(Constants.Strings.shootIn)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color("BackgroundColor"))
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
                        .foregroundColor(Color("TextColor"))
                }
                Color("DarkColor")
                    .frame(height: 1)
                    .opacity(0.5)
                if let entryText = model.reboundText {
                    Text(entryText)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 20, weight: .regular))
                        .padding(.bottom, 10)
                        .foregroundColor(Color("TextColor"))
                }
            }
            .padding([.top, .horizontal])
            
            JournaEntryPhotosView(model: model)
            // divider
            Color("DarkColor")
                .frame(height: 1)
                .padding(.horizontal)
                .opacity(0.5)
            JournaEntryFooterView(model: model)
        }
        .background(
            Color("ListColor").cornerRadius(16)
                .shadow(color: Color.black.opacity(0.1), radius: 10)
        )
        .overlay(RoundedRectangle(cornerRadius: 16)
            .stroke(Color("DarkColor"), lineWidth: 1))
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
    
    /// Entry header view with the mood icon and time
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
        }
        .foregroundColor(Color("TextColor"))
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
//                if let reasons = model.reasons?.components(separatedBy: ";") {
//                    ForEach(0..<reasons.count, id: \.self) { index in
//                        HStack {
//                            if let image = UIImage(named: reasons[index]) {
//                                Image(uiImage: image).resizable().aspectRatio(contentMode: .fit)
//                                    .frame(width: 18, height: 18, alignment: .center)
//                            }
//                            Text(reasons[index].capitalized).font(.system(size: 12))
//                        }
//                        .foregroundColor(Color("TextColor")).padding(.horizontal, 10).padding(.vertical, 5)
//                        .background(RoundedRectangle(cornerRadius: 20).stroke(Color("TextColor"), lineWidth: 1))
//                        .padding(.vertical, 5)
//                    }
//                }
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
        .foregroundColor(Color("TextColor"))
    }
}

// MARK: - Preview UI
struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(DataManager(preview: true))
    }
}
