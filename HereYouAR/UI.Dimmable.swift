//
//  UI.DimView.swift
//  MNFST
//
//  Created by Dmitry Purtov on 30/07/2019.
//  Copyright © 2019 MNFST. All rights reserved.
//

import UIKit

extension TK {
    enum Dimmable {}
}

extension TK.Dimmable {
    enum State {
        case active
        case inactive
    }
}


protocol _TKDimmable {
    func set(state: TK.Dimmable.State)
}
extension TK.Dimmable { typealias Slf = _TKDimmable }


extension UIView: TK.Dimmable.Slf {}


extension TK.Dimmable.Slf where Self: UIView {
    func set(state: TK.Dimmable.State) {
        switch state {
        case .active:
            self.alpha = 1.0
        case .inactive:
            self.alpha = 0.0
        }
    }
}


extension TK.Dimmable.Slf where Self: UIVisualEffectView {
    func set(state: TK.Dimmable.State) {
        switch state {
        case .active:
            effect = UIBlurEffect(style: .regular)
        case .inactive:
            effect = nil
        }
    }
}
