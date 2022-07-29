//
//  CommoditiesView.swift
//  Stocks
//
//  Created by Matthew Reddin on 25/02/2022.
//

import SwiftUI

struct CommoditiesView: View {
    
    @StateObject var commoditiesVM: CommoditiesViewModel
    let columns = 2
    
    var body: some View {
        GeometryReader { geo in
            if !commoditiesVM.quotes.isEmpty {
                let maxNameStringHeight = calculateMaxCellNameStringHeight(width: geo.size.width)
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.fixed((geo.size.width - (UIConstants.systemSpacing * Double(columns))) / 2)), count: columns)) {
                        ForEach(commoditiesVM.commoditySections, id: \.name) { section in
                            Section {
                                ForEach(section.commodities, id: \.symbol) { commodity in
                                    NavigationLink(destination: StockDetailView(stockDetailVM: StockQuoteDetailViewModel(service: commoditiesVM.stockService, stock: commoditiesVM.quotes[commodity.symbol]!))) {
                                        CommoditiesCellView(commodityItem: commodity, nameHeight: maxNameStringHeight)
                                            .environmentObject(commoditiesVM)
                                    }
                                }
                            } header: {
                                VStack(spacing: UIConstants.compactSystemSpacing) {
                                    Text(section.name)
                                        .font(.title2.weight(.semibold))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading)
                                    Rectangle()
                                        .fill(.linearGradient(colors: [Color(UIColor.systemGray4), Color(UIColor.systemBackground)], startPoint: .leading, endPoint: .trailing))
                                        .frame(height: 1)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
            } else if let message = commoditiesVM.errorMessage {
                Text(message)
                    .foregroundColor(.secondary)
            }
        }
        .navigationBarTitle("Commodities")
    }
    
    func calculateMaxCellNameStringHeight(width: Double) -> Double {
        let cellWidth = (width - (UIConstants.systemSpacing * Double(columns))) / 2
        var maxHeight = Double.leastNormalMagnitude
        let commodityNames = commoditiesVM.commoditySections.reduce([]) { partialResult, section in
            partialResult + section.commodities.map(\.name)
        }
        for name in commodityNames {
            let titleBoldAttribute = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1).addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.bold]])
            let nameStringHeight = (name as NSString).boundingRect(with: .init(width: cellWidth, height: .infinity), options: .usesLineFragmentOrigin, attributes: [.font: UIFont(descriptor: titleBoldAttribute, size: 0)], context: nil).height
            maxHeight = max(maxHeight, nameStringHeight)
        }
        return maxHeight
    }
}
