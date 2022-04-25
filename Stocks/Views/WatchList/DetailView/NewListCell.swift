//
//  NewListCell.swift
//  Stocks
//
//  Created by Matthew Reddin on 28/03/2022.
//

import SwiftUI

struct NewsListCell: View {
    
    let newsItem: NewsItem
    
    var body: some View {
        HStack {
            VStack(spacing: 0) {
                Text(newsItem.headline ?? "")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(newsItem.source ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(newsItem.summary ?? "")
                    .font(.caption)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, UIConstants.compactSystemSpacing)
                Text(newsItem.dateTime?.formatted(date: .abbreviated, time: .shortened) ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
    }
}


