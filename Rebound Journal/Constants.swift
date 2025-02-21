//
//  Constants.swift
//  Rebound Journal
//
//  Created by hyunho lee on 4/18/24.
//

import Foundation

struct Constants {
    struct Strings {
        // MARK: - Main
        static let mainTitle = "리바운드 저널"
        
        // MARK: - JournalEntryCreatorView
        
        // MARK: .isSuccess
        // “What experience would you like to record?”
        static let experienceToRecord = "어떤 경험을 기록할까요?"
        // “Start Shooting”
        static let startShooting = "슈팅 시작!"
        
        // MARK: .howFeelingNow
        // “Goal! Now I’ll let go of my emotions.”
        static let goalMessage = "골인! 이제 감정을 덜어낼게요"
        // “What feelings are you experiencing?”
        static let currentEmotion = "어떤 감정을 느끼고 있나요?"
        
        // MARK: .yourExperience
        // “Why do you feel this emotion?”
        static let emotionReason = "이 감정을 느끼게 된 이유가 뭘까요?"
        // “Tell me about this experience.”
        static let experienceDescription = "이번 경험에 대해 말해주세요."
        
        // MARK: .nextPlan
        // “What are your plans for the future?”
        static let futurePlans = "앞으로의 계획은 무엇인가요?"
        
        // MARK: .completeCreation
        // “Shooting Complete!”
        // “Shall we create a goal based on your experiences and plans?”
        static let shootingComplete = "슈팅 완료!"
        static let goalSuggestion = "경험과 계획을 참고해, 목표를 생성할까요?"
        
        // MARK: .mood(Lagacy)
        static let feelToday = "어떤 슛을 남겨볼까요?" //"Hello, how do you feel today?"
        static let reboundFeelToday = "그래서 그 슛을 다시 쏘고난 지금 기분은 어때요?" //"Hello, how do you feel today?"
        // MARK: .today(Lagacy)
        static let todayShoot = "오늘 쏘았던 슛은 어땠나요?"// "What shot did you shoot today?"
        static let reboundTodayShoot = "다시 쏘았던 슛은 어땠나요?"// "What shot did you shoot today?"
        // MARK: .shoot(Lagacy)
        static let howToRebound = "만족해요? 이 다음은 어떻게 할꺼에요?"// "How can you rebound?"
        static let reboundHowToRebound = "리바운드는 만족해요? 이 다음은 어떻게 할꺼에요?"// "How can you rebound?"
        // MARK: .plan(Lagacy)
        static let whatToDoNext = "앞으로의 계획은 무엇인가요?"
        static let completeShooting = "슈팅 완료!"
        static let whatIsTarget = "경험과 계획을 참고해, 목표를 생성할까요?"
        
        // MARK: .images(Lagacy)
        static let attachPhotos = "같이 붙일 사진이 있나요?"// "Do you want to attach any photos?"
        static let reboundAttachPhotos = "같이 붙일 사진이 있나요?"// "Do you want to attach any photos?"
        
        // MARK: - HomeView
        // MARK: CheckInBannerView
        static let oops = "이런!"
        static let reboundShootIn = "리바운드 슛!"
        static let past = "과거"
        static let future = "미래"
        static let shootInIsDisabled = "슛은 쏠 수 없어요"
        static let howIsYourDaySoFar = "오늘 하루 어때요?"
        static let shootIn = "슛-쏘기"
        
        // MARK: ReboundTextInputView
        static let doneEditing = "작성완료" //"Done Editing"
        static let nextStep = "다음으로" //"Next Step"
        static let submitEntry = "슛 쏘기" // "Submit Entry"
        
        // MARK: - SettingView
        static let setting = "설정"// "setting"
        static let appPasscode = "앱 비밀번호" // "App Passcode"
        static let setPasscode = "비밀번호 설정" // "Set Passcode"
        static let disablePasscode = "비밀번호 삭제" // "Disable Passcode"
        static let dailyReminders = "매일 알림"// "Daily Reminders"
        static let enableReminders = "알림 켜기"// "Enable Reminders"
        static let spreadTheWord = "소식을 퍼뜨리세요" // "Spread the Word"
        static let rateApp = "평점주기" // "Rate App"
        static let shareApp = "앱 공유하기" // "Share App"
        static let supportAndPrivacy = "지원 및 개인정보 보호" // "Support & Privacy"
        static let eMailUs = "개발자에게 메일 보내기" // "E-Mail us"
        static let privacyPolicy = "개인정보 보호정책"// "Privacy Policy"
        static let termsOfUse = "이용약관"// "Terms of Use"
        
        // MARK: - UnCased
        static let reShootIn = "다시-쏘기"
        static let noEntriesYet = "아직 슈팅 기록이 없어요"
        static let noEntriesYetDiscription = "한 번도 쓧을 쏘지 않았는데\n슛-쏘기 버튼을 눌러서 슛 쏴보는건 어때요?"
        static let whatWillNext = "그래서 이 다음은 어떻게 되는거에요?"//"Describe how was your day so far..."
        static let describeShoot = "오늘 쏘았던 슛은 얼마나 멀리 날아갔는지 최대한 자세하게 설명해주세요."//"Describe how was your day so far..."
        static let history = "이전 기록보기"// "History"
        static let whatIshoot = "내가 쐈던 슛은 이랬어요" // "What I shoot"
        static let myReboundPlan = "내 다음 계획은 이래요"// "My rebound plan"
        static let myMood = "지금 내 기분은"
        
        static let exitFlow = "정말 나가시나요?"// "Exit Flow"
        static let exitDescription = "지금 그만두시면 진행정보를 모두 잃게됩니다."//"Are you sure you want to leave this flow? You will lose your current progress"
        
    }
    // MARK: - ImageString
    struct ImageStrings {
        static let xMark = "xmark"
    }
}
