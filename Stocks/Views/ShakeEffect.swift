//
//  ShakeEffect.swift
//  Stocks
//
//  Created by Matthew Reddin on 01/03/2022.
//

import SwiftUI

// Applies an animated "shake" when the shakeIndex is incremented
struct ShakeEffect: GeometryEffect {

    var shakeIndex: CGFloat

    var animatableData: CGFloat {
        get {
            shakeIndex
        }
        set {
            shakeIndex = newValue
        }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        let amplitude = 8.0
        let frequency = 3.0
        return ProjectionTransform(CGAffineTransform(translationX: sin(shakeIndex * .pi * frequency) * amplitude, y: 0))
    }

}
