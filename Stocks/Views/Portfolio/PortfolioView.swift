//
//  PortfolioView.swift
//  Stocks
//
//  Created by Matthew Reddin on 28/02/2022.
//

import SwiftUI
import OrderedCollections
struct PortfolioView: View {
    
    @StateObject var portfolioVM: PortfolioViewModel
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        ZStack {
            VStack {
                if portfolioVM.portfolioStocks.count > 0 && portfolioVM.vaultStatus == .authorised {
                    PortfolioSortOrderPickerView(profitSort: $portfolioVM.portfolioSort)
                        PortfolioListView()
                            .environmentObject(portfolioVM)
                } else {
                    errorDisplayView
                }
            }
            .overlay(addStock, alignment: .top)
            if portfolioVM.editingIndex != nil {
                Color(uiColor: .systemGray).opacity(0.8)
                    .edgesIgnoringSafeArea(.all)
            }
            if let index = portfolioVM.editingIndex, index < portfolioVM.portfolioStocks.count {
                EditPortfolioStockView(numberOfShares: String(portfolioVM.portfolioStocks[index].numberOfShares), purchasePrice: String(portfolioVM.portfolioStocks[index].purchasePrice), portfolioStock: portfolioVM.portfolioStocks[index])
                    .environmentObject(portfolioVM)
            }
            if portfolioVM.showFaceIDAuthorisationScreen {
                FaceIDAuthorisationView()
                    .padding()
                    .environmentObject(portfolioVM)
            }
            if scenePhase != .active {
                // If the app is not active we will need to protect the user's financial information from appearing in the app switcher by adding an opaque view that protects the user's financial information.
                Color(uiColor: .systemBackground)
                    .transition(.opacity.animation(.linear))
            }
        }
        .alert(portfolioVM.errorMessage, isPresented: $portfolioVM.showAlert, actions: {})
        .safeAreaInset(edge: .bottom) {
            if portfolioVM.showPortfolioSummary && !portfolioVM.showAddStockView && scenePhase == .active {
                PortfolioSummary()
                    .frame(maxWidth: .infinity)
                    .background(Color(uiColor: .secondarySystemBackground).cornerRadius(UIConstants.cornerRadius).shadow(radius: UIConstants.cornerRadius))
                    .padding(.horizontal)
                    .environmentObject(portfolioVM)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
                    .padding(.bottom, UIConstants.systemSpacing)
            }
        }
        .task { [weak portfolioVM] in
            portfolioVM?.checkVaultAuthorisation()
        }
        .toolbar {
            viewToolBar
        }        .navigationBarTitle("Portfolio")
        .onChange(of: scenePhase) { _ in
            if scenePhase == .background {
                Task { [weak portfolioVM] in
                    portfolioVM?.checkVaultAuthorisation()
                }
            }
        }
    }
    
    @ViewBuilder
    var addStock: some View {
        if portfolioVM.showAddStockView {
            AddStockView(addStockVM: AddStockViewModel(service: StockService(provider: NetworkStockProvider()), appStocks: OrderedSet(portfolioVM.portfolioStocks.map(\.symbol))), showView: $portfolioVM.showAddStockView, addStock: portfolioVM.addStock(result:))
                .transition(.scale.combined(with: .opacity))
                .zIndex(1)
        }
    }
    
    @ToolbarContentBuilder
    var viewToolBar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                withAnimation(.linear) {
                    portfolioVM.showAddStockView = true
                }
            } label: {
                Image(systemName: "plus")
            }
                .disabled(portfolioVM.modalViewOnScreen || portfolioVM.vaultStatus != .authorised)
        }
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                withAnimation(.spring()) {
                    portfolioVM.showPortfolioSummary.toggle()
                }
            } label: {
                Text("Summary")
            }
            .disabled(portfolioVM.vaultStatus != .authorised || portfolioVM.portfolioStocks.isEmpty)
        }
    }
    
    var errorDisplayView: some View {
        VStack(spacing: UIConstants.systemSpacing * 2) {
            Text(portfolioVM.errorMessage)
                .foregroundColor(.secondary)
            if portfolioVM.vaultStatus != .authorised {
                Button {
                    Task { [weak portfolioVM] in
                        await portfolioVM?.accessPortfolio()
                    }
                } label: {
                    Text("Authenticate")
                        .bold()
                }
                .foregroundColor(.accentColor)
            } else {
                Text("Tap the plus button at the top of the screen to add a stock")
                    .foregroundColor(.secondary)
            }
        }
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
