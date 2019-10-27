//
//  Resources.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 27.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import UIKit

enum Resources {}

extension UIColor {
    convenience init(_ r: Int, _ g: Int, _ b: Int, _ a: CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
}

extension Resources {
    enum Colors {
        static let accentColor = UIColor(54, 220, 213)
        static let lightGray = UIColor(239, 239, 239)
    }

    enum Fonts {
        static func museoSans500(_ size: CGFloat) -> UIFont {
            return UIFont(name: "MuseoSansCyrl-500", size: size) ?? UIFont.systemFont(ofSize: size, weight: UIFont.Weight.regular)
        }

        static func museoSans700(_ size: CGFloat) -> UIFont {
            return UIFont(name: "MuseoSansCyrl-700", size: size) ?? UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
        }

        static func museoSans900(_ size: CGFloat) -> UIFont {
            return UIFont(name: "MuseoSansCyrl-900", size: size) ?? UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold)
        }
    }
}
