//
//  URLExtension.swift
//  Stocks
//
//  Created by Matthew Reddin on 14/04/2022.
//

import Foundation

extension URL: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return absoluteString.hash
    }
}
