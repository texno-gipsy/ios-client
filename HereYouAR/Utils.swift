//
//  Utils.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import Foundation

enum TK {
    static func fallback<ValueT>(_ value: ValueT) -> ValueT {
        assertionFailure()
        return value
    }
}
