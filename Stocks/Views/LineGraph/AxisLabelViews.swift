//
//  YAxisLabelsView.swift
//  Stocks
//
//  Created by Matthew Reddin on 31/08/2020.
//

import SwiftUI

struct YAxisLabelsView: View {
    
    let labels: [Double]
    let fractionPrecision: Int
    
    var body: some View {
        let lessThanOneCount = labels.count - 1
        return GeometryReader { geo in
            ForEach(Array(labels.indices), id: \.self) { index in
                Text(labels[index].formatted(.number.precision(.fractionLength(fractionPrecision))))
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .position(x: geo.size.width / 2, y: (geo.size.height / CGFloat(lessThanOneCount)) * CGFloat(index))
            }
        }
    }
}

struct XAxisLabelsView: View {
    
    let labels: [(Double, String)]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(Array(labels.indices), id: \.self) { index in
                    Text(labels[index].1)
                        .font(.system(size: 12))
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .position(x: labels[index].0 * geo.size.width, y: geo.size.height / 2)
                }
            }
        }
    }
}


