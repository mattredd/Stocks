//
//  WealthCalculator.swift
//  Stocks
//
//  Created by Matthew Reddin on 27/02/2022.
//

import Foundation

struct WealthCalculator {
    
    var currencyRates: [String: Double] = [:]
    
    // As British shares are priced in pence and not pounds we need to convert it to pounds
    func calculateCurrentWealth(from portfolio: [PortfolioStock]) -> Double? {
        var total = 0.0
        let baseCurrency = Locale.autoupdatingCurrent.currencyCode ?? "USD"
        for portfolioData in portfolio {
            let conversionRate = currencyRates[portfolioData.currency.uppercased()] ?? (baseCurrency == portfolioData.currency ? 1 : nil)
            guard let currencyConversion = conversionRate else { return nil }
            if portfolioData.currency == "GBp" {
                total += portfolioData.currentPrice / currencyConversion * Double(portfolioData.numberOfShares) / 100
            } else {
                total += portfolioData.currentPrice / currencyConversion * Double(portfolioData.numberOfShares)
            }
        }
        return total
    }
    
    func calculateOriginalWealth(from portfolio: [PortfolioStock]) -> Double? {
        var total = 0.0
        let baseCurrency = Locale.autoupdatingCurrent.currencyCode ?? "USD"
        for portfolioData in portfolio {
            let conversionRate = currencyRates[portfolioData.currency.uppercased()] ?? (baseCurrency == portfolioData.currency ? 1 : nil)
            guard let currencyConversion = conversionRate else { return nil }
            if portfolioData.currency == "GBp" {
                total += portfolioData.purchasePrice / currencyConversion * Double(portfolioData.numberOfShares) / 100
            } else {
                total += portfolioData.purchasePrice / currencyConversion * Double(portfolioData.numberOfShares)
            }
        }
        return total
    }
    
    func calculateProfit(from portfolio: [PortfolioStock]) -> Double? {
        if let currentWealth = calculateCurrentWealth(from: portfolio), let originalWealth = calculateOriginalWealth(from: portfolio) {
            return currentWealth - originalWealth
        } else {
            return nil
        }
    }
}
