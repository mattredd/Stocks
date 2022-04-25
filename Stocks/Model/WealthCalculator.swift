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
    func calculateCurrentWealth(from portfolio: [PortfolioStock]) -> Double {
        var total = 0.0
        for portfolioData in portfolio {
            guard let conversionRate = currencyRates[portfolioData.currency.uppercased()] else { continue }
            if portfolioData.currency == "GBp" {
                total += portfolioData.currentPrice / conversionRate * Double(portfolioData.numberOfShares) / 100
            } else {
                total += portfolioData.currentPrice / conversionRate * Double(portfolioData.numberOfShares)
            }
        }
        return total
    }
    
    func calculateOriginalWealth(from portfolio: [PortfolioStock]) -> Double {
        var total = 0.0
        for portfolioData in portfolio {
            guard let conversionRate = currencyRates[portfolioData.currency.uppercased()] else { continue }
            if portfolioData.currency == "GBp" {
                total += portfolioData.purchasePrice / conversionRate * Double(portfolioData.numberOfShares) / 100
            } else {
                total += portfolioData.purchasePrice / conversionRate * Double(portfolioData.numberOfShares)
            }
        }
        return total
    }
    
    func calculateProfit(from portfolio: [PortfolioStock]) -> Double {
        calculateCurrentWealth(from: portfolio) - calculateOriginalWealth(from: portfolio)
    }
}
