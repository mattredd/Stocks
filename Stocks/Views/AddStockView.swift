//
//  AddStockView.swift
//  Stocks
//
//  Created by Matthew Reddin on 15/02/2022.
//

import SwiftUI

struct AddStockView: View {
    
    @StateObject var addStockVM: AddStockViewModel
    @Binding var showView: Bool
    @FocusState private var textFieldFocused: Bool?
    let addStock: (StockQueryResult) async -> ()
    let frameHeight = 300.0
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Add Stock")
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .overlay(
                    Button {
                        withAnimation(.linear) {
                            showView = false
                        }
                    } label: {
                        Text("Cancel")
                    }
                    , alignment: .leading)
                TextField("Search Stocks", text: $addStockVM.searchTerm, prompt: Text("Search for stocks"))
                    .padding(UIConstants.systemSpacing)
                    .background(Color.white.cornerRadius(UIConstants.cornerRadius))
                    .submitLabel(.search)
                    .onSubmit {
                        Task { [weak addStockVM] in
                            await addStockVM?.findStocks(searchTerm: addStockVM?.searchTerm.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
                        }
                    }
                    .focused($textFieldFocused, equals: true)
                ZStack {
                    if addStockVM.foundStocks.count == 0 {
                        if addStockVM.isSearching {
                            ProgressView()
                                .transition(.opacity)
                        } else {
                            Text(addStockVM.searchMessage)
                                .foregroundColor(.secondary)
                                .transition(.opacity)
                        }
                    } else {
                        ZStack {
                            Color(uiColor: .systemBackground).cornerRadius(UIConstants.cornerRadius)
                            List(addStockVM.foundStocks, id: \.symbol) { result in
                                Button {
                                    Task {
                                        await addStock(result)
                                        withAnimation(.linear) {
                                            showView = false
                                        }
                                    }
                                } label: {
                                    StockNewsItemCell(stockQueryResult: result)
                                        .environmentObject(addStockVM)
                                }
                                .buttonStyle(.plain)
                                .disabled(addStockVM.appStocks.contains(result.symbol ?? ""))
                            }
                        }
                        .listStyle(.plain)
                        .cornerRadius(UIConstants.cornerRadius)
                        .transition(.opacity)
                    }
                }
                .frame(height: frameHeight)
            }
            .onAppear {
                textFieldFocused = true
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground).cornerRadius(UIConstants.cornerRadius).shadow(radius: UIConstants.cornerRadius))
            .padding()
            .zIndex(1)
            .animation(.linear, value: textFieldFocused)
            Spacer()
        }
        .animation(.linear, value: addStockVM.foundStocks.count)
    }
}


struct StockNewsItemCell: View {
    
    let stockQueryResult: StockQueryResult
    @EnvironmentObject var addStockVM: AddStockViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(stockQueryResult.longName ?? stockQueryResult.shortName ?? "-")
                Text(stockQueryResult.exchangeDisplay ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if addStockVM.appStocks.contains(stockQueryResult.symbol ?? "") {
                Image(systemName: "checkmark")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white)
                    .padding(UIConstants.compactSystemSpacing)
                    .background(Circle().fill(.green))
            }
            StockTypeView(type: stockQueryResult.typeDisplay ?? .unknown)
        }
        .contentShape(Rectangle())
    }
}
