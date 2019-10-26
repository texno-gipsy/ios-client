//
//  UniqueTokenGenerator.swift
//  ToolKit
//
//  Created by Dmitry Purtov on 25/08/2019.
//  Copyright © 2019 MNFST. All rights reserved.
//

import Foundation

extension TK {
    enum UniqueTokenGenerator {}
}


protocol _TKUniqueTokenGenerator {
    associatedtype TokenType
    
    func generate() -> TokenType
}
extension TK.UniqueTokenGenerator { typealias Slf = _TKUniqueTokenGenerator }


extension TK.UniqueTokenGenerator {
    
    class Default: Slf {
        var counter: Int = 0
        
        func generate() -> Int {
            counter += 1
            return counter
        }
    }
}
