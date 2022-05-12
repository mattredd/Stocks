//
//  PortfolioViewModel.swift
//  Stocks
//
//  Created by Matthew Reddin on 26/02/2022.
//

import SwiftUI

@MainActor
class PortfolioViewModel: ObservableObject {
    
    @Published var portfolioStocks: [PortfolioStock] = []
    @Published var showAddStockView = false
    @Published var showPortfolioSummary = false
    @Published var showFaceIDAuthorisationScreen = false
    // The index in portfolioStocks that is being edited and when non-nil the view will show the AddStockView
    @Published var editingIndex: Int?
    @Published var vaultStatus = VaultStatus.unauthorised
    @Published var errorMessage = ""
    @Published var showAlert = false
    var wealthCalculator = WealthCalculator()
    var portfolioSort: PortfolioProfitSort = .ascending {
        willSet {
            guard portfolioSort != newValue else { return }
            sortPortfolio(by: newValue)
        }
    }
    // The object that can access the portfolio data in a secure way using either the passcode or biometrics
    let portfolioVault: PortfolioAccess
    let stockService: StockService
    
    init(service: StockService, portfolioAccess: PortfolioAccess) {
        self.stockService = service
        self.portfolioVault = portfolioAccess
        Task { [weak self] in
            await self?.accessPortfolio()
            self?.wealthCalculator.currencyRates = (try? await service.convertCurrency(currencyCode: Locale.autoupdatingCurrent.currencyCode ?? "USD")) ?? [:]
        }
    }
    
    func accessPortfolio() async {
        if portfolioVault.grantedAccess { return }
        // Check whether we can use Face ID on the device and if so present the screen asking the user if they want to use Face ID before we request authorisation from the vault
        guard !portfolioVault.usesFaceID || showFaceIDAuthorisationScreen else {
            withAnimation(.linear) {
                showFaceIDAuthorisationScreen = true
            }
            return
        }
        withAnimation(.linear) {
            showFaceIDAuthorisationScreen = false
        }
        do {
            if try await portfolioVault.requestAccess() {
                vaultStatus = .authorised
                await accessData()
            }
        }
        catch {
            switch error as? AuthenticationError {
            case .cancelled:
                errorMessage = "Authentication was cancelled"
                vaultStatus = .cancelled
            case .noAuthorisationMethod:
                errorMessage = "To access your portfolio you will need to setup a passcode or enable biometric security as this screen contains personal financial information"
                vaultStatus = .noAuthorisationMethod
            default:
                errorMessage = "Authentication failed"
                vaultStatus = .unauthorised
            }
        }
    }
    
    func accessData() async {
        guard vaultStatus == .authorised else { return }
        portfolioStocks = (try? portfolioVault.fetchPortfolio()) ?? []
        if !portfolioStocks.isEmpty {
            await updateStockPrices()
            sortPortfolio(by: portfolioSort)
        }
        else {
            errorMessage = "You do not have any stocks in your portfolio"
        }
    }
    
    func checkVaultAuthorisation() {
        guard vaultStatus == .authorised && !portfolioVault.vaultStillAuthorised else {
            return
        }
        vaultStatus = .timedOut
        portfolioStocks.removeAll()
        errorMessage = "Access to the portfolio has expired"
    }
    
    func updateStockPrices() async {
        let quotes = (try? await stockService.fetchQuote(stocks: portfolioStocks.map(\.symbol))) ?? []
        for i in quotes.indices {
            if let price = quotes[i].marketPrice {
                portfolioStocks[i].currentPrice = price
            }
            portfolioStocks[i].lastUpdateDate = quotes[i].marketDate
        }
        savePortfolio()
    }
    
    func savePortfolio() {
        try? portfolioVault.storePortfolio(stocks: portfolioStocks)
    }
    
    func addStock(result: StockQueryResult) async {
        guard let symbol = result.symbol else { return }
        do {
            guard let quote = try await stockService.fetchQuote(stocks: [symbol]).first, let name = quote.name ?? quote.shortName, let symbol = quote.symbol, let currency = quote.currency, let price = quote.marketPrice, let type = quote.type, let date = quote.marketDate else {
                errorMessage = "Unable to retrieve stock data"
                showAlert = true
                return
            }
            let stockToAddToPortfolio = PortfolioStock(name: name, symbol: symbol, currency: currency, purchasePrice: 0, numberOfShares: 0, currentPrice: price, type: type, lastUpdateDate: date)
            portfolioStocks.append(stockToAddToPortfolio)
            try portfolioVault.storePortfolio(stocks: portfolioStocks)
            withAnimation(.linear) {
                // Let the user amend the stock
                editingIndex = portfolioStocks.count - 1
            }
        }
        catch {
            if let networkingError = (error as? APIErrors) {
                if case APIErrors.networkError = networkingError {
                    errorMessage = "Unable to add the stock due to a network error. Please try again"
                }
            } else {
                errorMessage = "Unable to add the stock due to an error. Please try again"
            }
            showAlert = true
        }
    }
    
    func deleteStock(index: Int) {
        portfolioStocks.remove(at: index)
        savePortfolio()
    }
    
    func editStock(index: Int) {
        editingIndex = index
    }
    
    func endEditing(cancelled: Bool, deleted: Bool = false, numberOfShares: Int? = nil, priceBoughtAt: Double? = nil) {
        guard let currentEditingIndex = editingIndex else { return }
        defer {
            editingIndex = nil
            sortPortfolio(by: portfolioSort)
            savePortfolio()
        }
        guard !deleted else {
            if let savedEditingIndex = editingIndex {
                editingIndex = nil
                portfolioStocks.remove(at: savedEditingIndex)
            }
            return
        }
        guard !cancelled, let numberOfShares = numberOfShares, let priceBoughtAt = priceBoughtAt else { return }
        portfolioStocks[currentEditingIndex].numberOfShares = numberOfShares
        portfolioStocks[currentEditingIndex].purchasePrice = priceBoughtAt
    }
    
    func removeStock(at index: Int) {
        portfolioStocks.remove(at: index)
    }
    
    func cancelAuthorisation() {
        vaultStatus = .cancelled
        errorMessage = "Authentication was cancelled"
        withAnimation(.linear) {
            showFaceIDAuthorisationScreen = false
        }
    }
    
    func sortPortfolio(by sortOption: PortfolioProfitSort) {
        withAnimation(.spring()) {
            portfolioStocks.sort { stockA, stockB in
                // When sorting we need to take into account the currency of each stock; so we convert each stock to the user's currency and then use that value to sort the portfolio
                let profitStockA = stockA.profit / (wealthCalculator.currencyRates[stockA.currency] ?? 1)
                let profitStockB = stockB.profit / (wealthCalculator.currencyRates[stockB.currency] ?? 1)
                if sortOption == .ascending {
                    return profitStockA < profitStockB
                } else {
                    return profitStockA > profitStockB
                }
            }
        }
    }
    
    // Tells the view whether there is a modal view presented and the view can adapt as neccessary
    var modalViewOnScreen: Bool {
        showFaceIDAuthorisationScreen || showAddStockView || showPortfolioSummary || editingIndex != nil
    }
    
}
