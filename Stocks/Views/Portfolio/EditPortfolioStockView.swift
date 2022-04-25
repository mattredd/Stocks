//
//  EditPortfolioStockView.swift
//  Stocks
//
//  Created by Matthew Reddin on 01/03/2022.
//

import SwiftUI

struct EditPortfolioStockView: View {
    
    @EnvironmentObject var portfolioVM: PortfolioViewModel
    @Environment(\.displayScale) var displayScale
    @State private var shakeIndex = 0.0
    @State var numberOfShares: String
    @State var purchasePrice: String
    let portfolioStock: PortfolioStock
    let backgroundOpacity = 0.5
    
    var body: some View {
            VStack {
                Text("Amend Stock")
                    .font(.title2.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .overlay(Button {
                        withAnimation(.spring()) {
                            portfolioVM.endEditing(cancelled: true)
                        }
                    } label: {
                        Text("Cancel")
                    }, alignment: .leading)
                Text(portfolioStock.name)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                HStack {
                    VStack {
                        Text("Number of Shares")
                            .bold()
                        TextField("Number of Shares", text: $numberOfShares)
                            .keyboardType(.numberPad)
                            .foregroundColor(Int(numberOfShares) != nil ? .primary : .red)
                            .padding(.horizontal, UIConstants.systemSpacing)
                            .padding(.vertical, UIConstants.compactSystemSpacing)
                            .background(RoundedRectangle(cornerRadius: UIConstants.compactCornerRadius).stroke(Color(uiColor: .systemGray4), lineWidth: 1 / displayScale).background(Color(uiColor: .systemBackground).opacity(backgroundOpacity).cornerRadius(UIConstants.compactCornerRadius)))
                    }
                    .frame(maxWidth: .infinity)
                    VStack {
                        Text("Purchase Price")
                            .bold()
                        TextField("Purchase Price", text: $purchasePrice)
                            .keyboardType(.decimalPad)
                            .foregroundColor(Double(purchasePrice) != nil ? .primary : .red)
                            .padding(.horizontal, UIConstants.systemSpacing)
                            .padding(.vertical, UIConstants.compactSystemSpacing)
                            .background(RoundedRectangle(cornerRadius: UIConstants.compactCornerRadius).stroke(Color(uiColor: .systemGray4), lineWidth: 1 / displayScale).background(Color(uiColor: .systemBackground).opacity(backgroundOpacity).cornerRadius(UIConstants.compactCornerRadius)))
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical, UIConstants.systemSpacing)
                HStack {
                    Button(role: .destructive) {
                        withAnimation(.spring()) {
                            portfolioVM.endEditing(cancelled: false, deleted: true, numberOfShares: 0, priceBoughtAt: 0)
                        }
                    } label: {
                        Text("Delete")
                    }
                    .buttonStyle(.borderedProminent)
                    Button {
                        withAnimation(.spring()) {
                            if let price = Double(purchasePrice), let shares = Int(numberOfShares) {
                                portfolioVM.endEditing(cancelled: false, numberOfShares: shares, priceBoughtAt: price)
                            } else {
                                shakeIndex += 1
                            }
                        }
                    } label: {
                        Text("Confirm")
                    }
                    .modifier(ShakeEffect(shakeIndex: shakeIndex))
                .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground).cornerRadius(10))
            .padding(.horizontal)
            .transition(.opacity)
            .zIndex(1)
    }
}
