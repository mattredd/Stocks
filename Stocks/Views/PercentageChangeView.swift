//
//  PercentageChangeView.swift
//  Stocks
//
//  Created by Matthew Reddin on 29/03/2022.
//

import SwiftUI

struct PercentChangeView: View {
    
    let percentageChange: Double?
    
    var body: some View {
        HStack(spacing: UIConstants.compactSystemSpacing) {
            Image(systemName: percentageChange ?? 0 < 0 ? "arrowtriangle.down.fill" : "arrowtriangle.up.fill")
            Text("\(percentageChange?.formatted(.number.precision(.fractionLength(2)).sign(strategy: .never)) ?? "-")%")
                .bold()
        }
        .foregroundColor(.white)
        .padding(UIConstants.compactSystemSpacing)
        .background(percentageChange ?? 0 < 0 ? .red : .green)
        .cornerRadius(UIConstants.compactCornerRadius)
    }
}
