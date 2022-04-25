//
//  StocksTests.swift
//  StocksTests
//
//  Created by Matthew Reddin on 02/02/2022.
//

import XCTest
@testable import Stocks

class WealthCalculatorTests: XCTestCase {
    
    var wealthCalculator = WealthCalculator()
    // Use GBP as base currency
    let currencyRates = ["GBP": 1, "USD": 1.3, "JPN": 140.0]
    var GBPPortfolioStocks: [PortfolioStock] = []
    var USDPortfolioStocks: [PortfolioStock] = []
    var JPNPortfolioStocks: [PortfolioStock] = []
    let numberOfShares = 100

    override func setUpWithError() throws {
        wealthCalculator.currencyRates = currencyRates
        GBPPortfolioStocks.append(PortfolioStock(name: "", symbol: "", currency: "GBp", purchasePrice: 100, numberOfShares: numberOfShares, currentPrice: 100, type: .unknown))
        GBPPortfolioStocks.append(PortfolioStock(name: "", symbol: "", currency: "GBp", purchasePrice: 100, numberOfShares: numberOfShares, currentPrice: 80, type: .unknown))
        GBPPortfolioStocks.append(PortfolioStock(name: "", symbol: "", currency: "GBp", purchasePrice: 100, numberOfShares: numberOfShares, currentPrice: 120, type: .unknown))
        USDPortfolioStocks.append(PortfolioStock(name: "", symbol: "", currency: "USD", purchasePrice: 100, numberOfShares: numberOfShares, currentPrice: 50, type: .unknown))
        JPNPortfolioStocks.append(PortfolioStock(name: "", symbol: "", currency: "JPN", purchasePrice: 100, numberOfShares: numberOfShares, currentPrice: 1000, type: .unknown))
    }
    
    func testBaseCurrencyStocksCalculation() throws {
        let currentGBPWealth = wealthCalculator.calculateCurrentWealth(from: GBPPortfolioStocks)
        XCTAssert(currentGBPWealth == GBPPortfolioStocks.map { Double(numberOfShares) * $0.currentPrice }.reduce(0, +) / 100.0)
        let originalGBPWealth = wealthCalculator.calculateOriginalWealth(from: GBPPortfolioStocks)
        XCTAssert(originalGBPWealth == GBPPortfolioStocks.map { Double(numberOfShares) * $0.purchasePrice }.reduce(0, +) / 100)
    }

    func testWealthCalculations() throws {
        XCTAssert(wealthCalculator.calculateOriginalWealth(from: USDPortfolioStocks) == USDPortfolioStocks.map { Double(numberOfShares) * $0.purchasePrice }.reduce(0, +) / currencyRates["USD"]!)
        XCTAssert(wealthCalculator.calculateOriginalWealth(from: JPNPortfolioStocks) == JPNPortfolioStocks.map { Double(numberOfShares) * $0.purchasePrice }.reduce(0, +) / currencyRates["JPN"]!)
        XCTAssert(wealthCalculator.calculateCurrentWealth(from: USDPortfolioStocks) == USDPortfolioStocks.map { Double(numberOfShares) * $0.currentPrice }.reduce(0, +) / currencyRates["USD"]!)
        XCTAssert(wealthCalculator.calculateCurrentWealth(from: JPNPortfolioStocks) == JPNPortfolioStocks.map { Double(numberOfShares) * $0.currentPrice }.reduce(0, +) / currencyRates["JPN"]!)
        let totalOriginalWealth = wealthCalculator.calculateOriginalWealth(from: GBPPortfolioStocks + USDPortfolioStocks + JPNPortfolioStocks)
        let calculatedTotalOrignalWealth: Double = (GBPPortfolioStocks + USDPortfolioStocks + JPNPortfolioStocks).map { stock in
            if stock.currency != "GBp" {
                return Double(numberOfShares) * stock.purchasePrice / currencyRates[stock.currency]!
            } else {
                return Double(numberOfShares) * stock.purchasePrice / 100
            }
        }.reduce(0, +)
        XCTAssert(calculatedTotalOrignalWealth == totalOriginalWealth)
        let totalCurrentWealth = wealthCalculator.calculateCurrentWealth(from: GBPPortfolioStocks + USDPortfolioStocks + JPNPortfolioStocks)
        let calculatedTotalCurrentWealth: Double = (GBPPortfolioStocks + USDPortfolioStocks + JPNPortfolioStocks).map { stock in
            if stock.currency != "GBp" {
                return Double(numberOfShares) * stock.currentPrice / currencyRates[stock.currency]!
            } else {
                return Double(numberOfShares) * stock.currentPrice / 100
            }
        }.reduce(0, +)
        XCTAssert(calculatedTotalCurrentWealth == totalCurrentWealth)
        XCTAssert(wealthCalculator.calculateProfit(from: GBPPortfolioStocks + USDPortfolioStocks + JPNPortfolioStocks) == calculatedTotalCurrentWealth - calculatedTotalOrignalWealth)
    }

}
