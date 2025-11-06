//
//  Color+Extension.swift
//  Rebound Journal
//
//  Created by Leeo on 4/19/24.
//

import SwiftUI

extension Color {
    enum Bg {
        static let nextButtonDisabled = Color("Gray200")
        static let modalNavigateButton = Color("Gray900")
        static let selectedTagInReviewPlanView = Color("Gray300")
        
        // MARK: Home/Dashboard
        static let goalFreqLow = Color("Orange100")
        static let goalFreqMid = Color("Gray200")
        static let goalFreqHigh = Color("Orange400")
        
        // MARK: Chart
        static let goalInChart = Color("Orange500")
        static let reboundChart = Color("Orange200")
        static let shootLogDetail = Color("Gray200")
        
        // MARK: EmotionView
        static let selectedTag = Color("Orange200")
        static let unselectedTag = Color("Gray300")
        
        // MARK: Target
        static let goalListCell = Color("Gray400")
    }
    enum Text {
        
        static let primaryWhite = Color("Gray100")
        static let primaryBlack = Color("Gray900")
        static let secondary = Color("Gray400")
        
        static let shootCreationHeaderTitle = Color("Gray900")
        static let shootCreationHeaderSubtitle = Color("Gray700")
        
        static let selectTargetTitle = Color("Gray900")
        static let selectTargetSubtitle = Color("Gray400")
        
        static let goalListTitle = Color("Gray900")
        static let goalListCount = Color("Gray800")
        
        static let dashboardTitle = Color("Gray900")
        static let backButton = Color("Gray900")
        static let nextButton = Color("GrayWhite")
        static let nextButtonDisabled = Color("Gray500")
        
        static let shootLogDescription = Color("Gray700")
        
        // MARK: EmotionView
        static let selectedTag = Color("Orange500")
        static let unselectedTag = Color("Gray900")
    }
    enum Border {
        static let backButton = Color("Gray400")
        static let selectedShootType = Color("Orange500")
        static let unSelectedShootType = Color("Gray400")
    }
}
