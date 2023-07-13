//
//  DataManager.swift
//  Rebound Journal
//
//  Created by hyunho lee on 2023/06/10.
//

import SwiftUI
import CoreData
import Foundation


/// Full Screen flow
enum FullScreenMode: Int, Identifiable {
    case entryCreator, premium, passcodeView, setupPasscodeView, readJournalView
    var id: Int { hashValue }
}

/// Main data manager for the app
class DataManager: NSObject, ObservableObject {
    
    /// Dynamic properties that the UI will react to
    @Published var showLoading: Bool = false
    @Published var fullScreenMode: FullScreenMode?
    @Published var performance: [String: MoodLevel] = [String: MoodLevel]()
    @Published var selectedDate: Date = Date()
    @Published var selectedEntryImage: UIImage?
    @Published var seledtedEntry: JournalEntry?
    @Published var quotes: QuotesList = QuotesList()
    @Published var didEnterCorrectPasscode: Bool = false
    
    /// Dynamic properties that the UI will react to AND store values in UserDefaults
    @AppStorage("savedPasscode") var savedPasscode: String = ""
    @AppStorage("enableReminders") var enableReminders: Bool = false
    @AppStorage("reminderTime") var reminderTime: String = "9:00 AM"
    @AppStorage(AppConfig.premiumVersion) var isPremiumUser: Bool = false
    //{
        //didSet { Interstitial.shared.isPremiumUser = isPremiumUser }
    //}
    
    /// Core Data container with the database model
    let container: NSPersistentContainer = NSPersistentContainer(name: "Database")
    
    /// Default init method. Load the Core Data container
    init(preview: Bool = false) {
        super.init()
        if preview {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, _ in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
        fetchQuotesData()
    }
    
    /// Calendar days
    var calendarDays: [Date] {
        var days = [Date]()
        for index in 0..<AppConfig.headerTitleDaysCount {
            let date = Calendar(identifier: .gregorian).date(byAdding: .day, value: -index, to: Date())!
            days.append(date)
        }
        days.removeLast()
        days.insert(Calendar(identifier: .gregorian).date(byAdding: .day, value: 1, to: Date())!, at: 0)
        return days.reversed()
    }
    
    /// Fetch all quotes from local `Quotes` json
    private func fetchQuotesData() {
        guard let path = Bundle.main.path(forResource: "Quotes", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
              let models = try? JSONDecoder().decode(QuotesList.self, from: data)
        else { return }
        quotes = models.shuffled()
    }
}

// MARK: - Save Journal Entry to Core Data
extension DataManager {
    /// Save journal entries to Core Data
    func saveEntry(text: String, moodLevel: Int, moodText: String, reboundText: String, reasons: [MoodReason],isRebounded: Bool = false, images: [UIImage]) {
        let entryModelId = UUID().uuidString
        let entryModel = JournalEntry(context: container.viewContext)
        entryModel.id = entryModelId
        entryModel.text = text
        entryModel.isRebounded = isRebounded
        entryModel.moodLevel = Int16(moodLevel)
        entryModel.moodText = moodText
        entryModel.reboundText = reboundText
        entryModel.reasons = reasons.map({ $0.rawValue }).joined(separator: ";")
        for index in 0..<images.count {
            saveImage(images[index], id: "\(entryModelId)-\(index)-thumbnail", thumbnail: true)
            saveImage(images[index], id: "\(entryModelId)-\(index)", thumbnail: false)
        }
        entryModel.date = Date()
        try? container.viewContext.save()
    }
    
    /// Save journal entry image to documents folder
    func saveImage(_ image: UIImage, id: String, thumbnail: Bool) {
        let maxImageWidth = UIScreen.main.bounds.width/2
        let thumbnailQuality = 0.6
        let originalQuality = 0.9
        if thumbnail {
            if let thumbnailData = image.resizeImage(newWidth: maxImageWidth).jpegData(compressionQuality: thumbnailQuality) {
                saveImage(data: thumbnailData, id: id)
            }
        } else {
            if let imageData = image.jpegData(compressionQuality: originalQuality) {
                saveImage(data: imageData, id: id)
            }
        }
    }
}

// MARK: - Save/Fetch image from documents folder
extension DataManager {
    /// Load image from documents folder
    func loadImage(id: String) -> UIImage? {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        if let imageData = try? Data(contentsOf: documentsUrl.appendingPathComponent("\(id).jpg")) {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    /// Save image to the documents folder
    func saveImage(data: Data, id: String) {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentsUrl.appendingPathComponent("\(id).jpg")
        try? data.write(to: fileURL, options: .atomic)
    }
}

// MARK: - Load images from documents
extension DataManager {
    /// Load images for a journal entry id
    func loadImages(id: String, thumbnails: Bool = true) -> [UIImage]? {
        var images = [UIImage]()
        let imageName = "\(id)-index\(thumbnails ? "-thumbnail" : "")"
        for index in 0..<4 {
            let updatedName = imageName.replacingOccurrences(of: "index", with: "\(index)")
            if let image = loadImage(id: updatedName) {
                image.accessibilityIdentifier = updatedName
                images.append(image)
            }
        }
        return images
    }
}

// MARK: - Core Data Stats data
extension DataManager {
    /// Get stats data based on highlights type
//    func fetchStats(type: HighlightType) -> String {
//        let fetchRequest: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
//
//        /// Get all core data results for current year
//        if let results = try? container.viewContext.fetch(fetchRequest) {
//            let items = results.filter({ $0.date?.year == Date().year }).filter({ $0.date?.longFormat != Date().longFormat })
//            var journalEntryDays: String = ""
//            var monthlyEntries: [String: Int] = [String: Int]()
//            var moodMonthlyEntries: [String: Double] = [String: Double]()
//            let uniqueEntries = Set(items.map({ $0.date?.longFormat ?? "" })).sorted(by: > )
//
//            /// Iterate through all entries and find gaps between dasy
//            uniqueEntries.enumerated().forEach { index, entry in
//                if let entryDate = entry.date {
//                    journalEntryDays.append("<\(entry)>")
//                    if index < (uniqueEntries.count-1) {
//                        if let nextEntryDate = uniqueEntries[index+1].date {
//                            if Calendar.current.numberOfDaysBetween(nextEntryDate, and: entryDate) > 1 {
//                                journalEntryDays.append("-")
//                            }
//                        }
//                    }
//
//                    /// Calculate total number of entries for a month
//                    let entries = items.filter({ $0.date?.month == entryDate.month }).count
//                    if monthlyEntries[entryDate.month] == nil { monthlyEntries[entryDate.month] = entries }
//
//                    /// Calculate the mood average for a month
//                    let mood = items.filter({ $0.date?.month == entryDate.month }).map({ $0.moodLevel })
//                    if moodMonthlyEntries[entryDate.month] == nil {
//                        moodMonthlyEntries[entryDate.month] = Double(mood.reduce(0, +)) / Double(mood.count)
//                    }
//                }
//            }
//
//            /// If yesterday the user had no entries, then break the current streak
//            if !uniqueEntries.contains(Calendar.current.yesterday.longFormat) {
//                journalEntryDays.insert("-", at: journalEntryDays.startIndex)
//            }
//
//            /// Get the streak values from formatted journalEntryDays string
//            switch type {
//            case .currentStreak:
//                if let first = journalEntryDays.components(separatedBy: "-")
//                    .filter({ !$0.isEmpty }).first, !journalEntryDays.starts(with: "-") {
//                    return "\(first.components(separatedBy: "<").filter({ !$0.isEmpty }).count) Days"
//                }
//            case .longestStreak:
//                if let sorted = journalEntryDays.components(separatedBy: "-")
//                    .filter({ !$0.isEmpty }).sorted(by: { $0.count > $1.count }).first {
//                    return "\(sorted.components(separatedBy: "<").filter({ !$0.isEmpty }).count) Days"
//                }
//            case .mostEntries:
//                if let month = monthlyEntries.sorted(by: { $0.value > $1.value }).first?.key {
//                    return month
//                }
//            case .theHappiest:
//                if let month = moodMonthlyEntries.sorted(by: { $0.value > $1.value }).first?.key {
//                    return month
//                }
//            }
//        }
//
//        return "- -"
//    }
//
//    /// Fetch mood data for current week only
//    func fetchWeeklyMoodData() {
//        let currentWeek = Array(calendarDays.dropLast().sorted().suffix(7)).compactMap({ $0.longFormat })
//        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
//        let datePredicate = NSPredicate(format: "date > %@", oneWeekAgo as NSDate)
//        let fetchRequest: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
//        fetchRequest.predicate = datePredicate
//
//        /// Get all core data results for current week
//        if let results = try? container.viewContext.fetch(fetchRequest) {
//            var performanceData = [String: MoodLevel]()
//            currentWeek.forEach { date in
//                let mood = results.filter({ $0.date?.longFormat == date }).map({ $0.moodLevel })
//                if mood.count > 0 {
//                    performanceData[date] = MoodLevel(rawValue: Int(mood.reduce(0, +)) / mood.count)
//                }
//            }
//            DispatchQueue.main.async {
//                self.performance = performanceData
//            }
//        }
//    }
//
//    /// Fetch mood levels and entries by reason
//    func fetchMoodLevels(forReason reason: MoodReason) -> (levels: [MoodLevel], count: Int) {
//        let reasonPredicate = NSPredicate(format: "reasons CONTAINS[c] %@", reason.rawValue)
//        let fetchRequest: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
//        fetchRequest.predicate = reasonPredicate
//
//        /// Get all core data results matching a given reason
//        if let results = try? container.viewContext.fetch(fetchRequest) {
//            var moodLevels = [MoodLevel]()
//            results.forEach { entry in
//                if let level = MoodLevel(rawValue: Int(entry.moodLevel)) {
//                    moodLevels.append(level)
//                }
//            }
//            return (Array(Set(moodLevels)).sorted(by: { $0.rawValue < $1.rawValue }), moodLevels.count)
//        }
//
//        return ([], 0)
//    }
}

// MARK: - Schedule daily reminders
extension DataManager {
    
    /// Schedule a daily reminder if needed
    func scheduleDailyReminderIfNeeded() {
        func removePendingNotifications() {
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications()
            center.removeAllPendingNotificationRequests()
        }
        
        if enableReminders {
            removePendingNotifications()
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "Rebound Shoot-In"
            notificationContent.body = "Don't forget to write your journal today!"
            notificationContent.sound = .default
            let trigger = UNCalendarNotificationTrigger(dateMatching: reminderTime.dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "reminder", content: notificationContent, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { _ in }
        } else {
            removePendingNotifications()
        }
    }
    
}
