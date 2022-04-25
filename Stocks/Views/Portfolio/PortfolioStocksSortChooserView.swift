//
//  PortfolioSortChooserView.swift
//  Stocks
//
//  Created by Matthew Reddin on 23/03/2022.
//

import SwiftUI

struct PortfolioStocksListSortMethodView: View {
    
    @Binding var profitSort: PortfolioProfitSort
    @Namespace var animationNS
    let markerHeight = 3.0
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Text("Ascending")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .colorMultiply(profitSort == .ascending ? .orange : .primary)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, UIConstants.systemSpacing)
                    .overlay(Rectangle().fill(.clear).frame(height: markerHeight).matchedGeometryEffect(id: "sortChooser", in: animationNS, isSource: profitSort == .ascending), alignment: .bottom)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            profitSort = .ascending
                        }
                    }
                Rectangle()
                    .fill(.secondary)
                    .frame(width: UIConstants.lineWidth / 2)
                    .padding(.vertical, UIConstants.compactSystemSpacing)
                Text("Descending")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .colorMultiply(profitSort != .ascending ? .orange : .primary)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, UIConstants.systemSpacing)
                    .overlay(Rectangle().fill(.clear).frame(height: markerHeight).matchedGeometryEffect(id: "sortChooser", in: animationNS, isSource: profitSort != .ascending), alignment: .bottom)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            profitSort = .descending
                        }
                    }
            }
            .fixedSize(horizontal: false, vertical: true)
            Capsule().fill(.orange).frame(height: markerHeight).padding(.horizontal).matchedGeometryEffect(id: "sortChooser", in: animationNS, isSource: false)
        }
    }
}

struct PortfolioSortChooserView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioStocksListSortMethodView(profitSort: .constant(.ascending))
    }
}
