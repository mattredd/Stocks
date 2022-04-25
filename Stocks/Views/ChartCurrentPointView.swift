//
//  ChartCurrentPointView.swift
//  Stocks
//
//  Created by Matthew Reddin on 18/02/2022.
//

import SwiftUI

struct ChartCurrentPointView: View {
    
    @State private var started = false
    let colour: Color
    let startedViewScale = 2.5
    let identityScale = 1.0
    let animationDuration = 1.0
    let animationDelay = 0.5
    
    var body: some View {
        ZStack {
            Circle()
                .fill(colour)
            Circle()
                .strokeBorder(colour, lineWidth: started ? 0 : 1)
                .scaleEffect(started ? startedViewScale : identityScale)
        }
        .onAppear {
            withAnimation(.easeIn(duration: animationDuration).delay(animationDelay).repeatForever(autoreverses: false)) {
                started = true
            }
        }
    }
}

struct ChartCurrentPointViewProvider_Previews: PreviewProvider {
    static var previews: some View {
        ChartCurrentPointView(colour: .orange)
            .frame(width: 15, height: 15)
    }
}
