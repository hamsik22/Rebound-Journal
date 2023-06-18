//
//  AppConfig.swift
//  Rebound Journal
//
//  Created by hyunho lee on 2023/06/10.
//

import SwiftUI
import Foundation

/// Generic configurations for the app
class AppConfig {
    
    /// This is the AdMob Interstitial ad id
    /// Test App ID: ca-app-pub-3940256099942544~1458002511
//    static let adMobAdId: String = "ca-app-pub-3940256099942544/4411468910"
    
    // MARK: - Settings flow items
    static let emailSupport = "leeo@kakao.com"
    static let privacyURL: URL = URL(string: "https://www.google.com/")!
    static let termsAndConditionsURL: URL = URL(string: "https://www.google.com/")!
    static let yourAppURL: URL = URL(string: "https://apps.apple.com/app/idXXXXXXXXX")!
    
    // MARK: - Generic configurations
    static let headerTitleDaysCount: Int = 90
    
    // MARK: - In App Purchases
    static let premiumVersion: String = "ReboundJournal.Premium"
}

// MARK: - Mood Level Configurations
enum MoodLevel: Int, CaseIterable, Identifiable {
    case level1 = 1, level2//, level3, level4, level5
    var id: Int { hashValue }
    
    /// Mood text options
    var moodOptions: [String] {
        switch self {
        case .level1:
            return ["Brave", "Confident", "Creative", "Excited", "Free", "Happy", "Love", "Proud", "Respected"]//["Angry", "Anxious", "Disgusted", "Embarrassed", "Fearful", "Frustrated"]
        case .level2:
            return ["Annoyed", "Insecure", "Jealous", "Lonely", "Nervous", "Sad"]
//        case .level3:
//            return ["Awkward", "Bored", "Busy", "Confused", "Desire", "Impatient", "Tired"]
//        case .level4:
//            return ["Appreciated", "Calm", "Curious", "Grateful", "Inspired", "Motivated", "Satisfied"]
//        case .level5:
//            return ["Brave", "Confident", "Creative", "Excited", "Free", "Happy", "Love", "Proud", "Respected"]
        }
    }
    
    /// Mood chart percentage
    var chartValue: CGFloat {
        switch self {
        case .level1: return 15
        case .level2: return 25
//        case .level3: return 50
//        case .level4: return 75
//        case .level5: return 95
        }
    }
    
    /// Mood chart color
    var chartColor: Color {
        switch self {
        case .level1: return [Color(#colorLiteral(red: 0.9837132096, green: 0.4513888955, blue: 0.4547883272, alpha: 1))][0]
        case .level2: return [Color(#colorLiteral(red: 0.9979071021, green: 0.6928624511, blue: 0.4608915448, alpha: 1))][0]
//        case .level3: return [Color(#colorLiteral(red: 0.7912710309, green: 0.7962428927, blue: 0.7918474674, alpha: 1))][0]
//        case .level4: return [Color(#colorLiteral(red: 0.4645724893, green: 0.8924402595, blue: 0.8699511886, alpha: 1))][0]
//        case .level5: return [Color(#colorLiteral(red: 0.3809461594, green: 0.6858740449, blue: 1, alpha: 1))][0]
        }
    }
}

// MARK: - Mood Reasons
enum MoodReason: String, CaseIterable, Identifiable {
    case work, friends, nature, pets, fitness, travel, gaming, shopping
    var id: Int { hashValue }
}

