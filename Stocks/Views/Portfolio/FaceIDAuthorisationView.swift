//
//  FaceIDAuthorisationView.swift
//  Stocks
//
//  Created by Matthew Reddin on 03/03/2022.
//

import SwiftUI

struct FaceIDAuthorisationView: View {
    
    @EnvironmentObject var portfolioVM: PortfolioViewModel
    let frameWidth = 200.0
    
    var body: some View {
        VStack(spacing: UIConstants.systemSpacing * 2) {
            Image(systemName: "faceid")
                .font(.title)
                .foregroundColor(.blue)
            VStack {
                Text("Authorise access to your portfolio with Face ID")
                    .font(.headline)
                    .padding(.bottom, UIConstants.compactSystemSpacing)
                Text("You can use your passcode if you do not have Face ID setup")
                    .font(.footnote)
            }
            .multilineTextAlignment(.center)
            HStack {
                Button {
                    portfolioVM.cancelAuthorisation()
                } label: {
                    Text("Cancel")
                }
                .frame(maxWidth: .infinity)
                Divider()
                Button {
                    Task { [weak portfolioVM] in
                        await portfolioVM?.accessPortfolio()
                    }
                } label: {
                    Text("Authorise")
                }
                .frame(maxWidth: .infinity)
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: frameWidth)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: UIConstants.cornerRadius))
    }
}
