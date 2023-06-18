//
//  QuotesList.swift
//  Rebound Journal
//
//  Created by hyunho lee on 2023/06/10.
//

import Foundation

/// A list of quotes models
typealias QuotesList = [QuoteModel]

/// A model representing a quote
struct QuoteModel: Codable, Identifiable {
    let id: String
    let category: String
    let text: String
}
