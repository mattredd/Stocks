//
//  NewsItem.swift
//  Stocks
//
//  Created by Matthew Reddin on 15/02/2022.
//

import Foundation

struct NewsItem: Codable, Identifiable, Equatable {
    
    let dateTime: Date?
    let headline: String?
    let id: Int?
    let source: String?
    let summary: String?
    let url: URL?
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "datetime"
        case headline, id, source, summary, url
    }
}
