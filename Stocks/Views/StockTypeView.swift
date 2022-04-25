//
//  StockTypeView.swift
//  Stocks
//
//  Created by Matthew Reddin on 17/02/2022.
//

import SwiftUI

struct StockTypeView: View {
    
    let type: StockType
    
    var body: some View {
        Text(type.rawValue.uppercased())
            .font(.caption.bold())
            .padding(UIConstants.compactSystemSpacing)
            .overlay(RoundedRectangle(cornerRadius: UIConstants.compactCornerRadius).stroke(backgroundColour, lineWidth: UIConstants.lineWidth))
            .foregroundColor(backgroundColour)
    }
    
    var backgroundColour: Color {
        switch type {
        case .equity:
            return .blue
        case .fund:
            return .orange
        case .index:
            return .red
        case .currency:
            return .green
        case .future:
            return .brown
        case .ETF:
            return .purple
        case .unknown:
            return .primary
        }
    }
}

struct StockTypeView_Previews: PreviewProvider {
    static var previews: some View {
        StockTypeView(type: .equity)
    }
}
