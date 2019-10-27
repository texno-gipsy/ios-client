//
//  UIStyler.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 27.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import UIKit

class UIStyler {
    func applyMapStyle(to userView: UserView) {
        userView.layer.cornerRadius = 8
        userView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        TK.apply(shadow: TK.logoShadow, to: userView.layer)
        userView.backgroundColor = .white
    }
}

extension TK {
    public struct Shadow {
        public let color: UIColor
        public let opacity: CGFloat
        public let radius: CGFloat
        public let offset: CGSize

        public init(color: UIColor, opacity: CGFloat, radius: CGFloat, offset: CGSize) {
            self.color = color
            self.opacity = opacity
            self.radius = radius
            self.offset = offset
        }
    }

    public static func apply(shadow: Shadow, to layer: CALayer) {
        layer.shadowColor = shadow.color.cgColor
        layer.shadowOpacity = Float(shadow.opacity)
        layer.shadowRadius = shadow.radius
        layer.shadowOffset = shadow.offset
    }

    public static let logoShadow = Shadow(color: UIColor.black, opacity: 0.2, radius: 16.0, offset: CGSize(width: 0.0, height: 1.0))

    public static let accentShadow = Shadow(color: Resources.Colors.accentColor, opacity: 0.5, radius: 12.0, offset: CGSize(width: 0.0, height: 1.0))
}
