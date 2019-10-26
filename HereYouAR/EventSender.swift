//
//  EventSender.swift
//  MNFST
//
//  Created by Dmitry Purtov on 08/07/2019.
//  Copyright © 2019 MNFST. All rights reserved.
//

import Foundation

extension TK {
    
    public final class EventSender<EventT> {
        
        public init() {}
        
        public var onBecomeActive: (() -> Void)?
        
        public func send(_ event: EventT) {
            for (_, subscription) in subscriptions {
                if subscription.condition(event) {
                    subscription.block(event)
                }
            }
        }
        
        public func subscribe(condition: @escaping (EventT) -> Bool = { _ in true }, block: @escaping (EventT) -> Void) -> Disposable.Slf {
            let token = tokenGenerator.generate()
            guard subscriptions[token] == nil else {
                assertionFailure("subscriptions[\(token)] already exists")
                return Disposable.Base {}
            }
            subscriptions[token] = Subscription(condition: condition, block: block)
            return Disposable.Base { [weak self] in
                guard let self = self else { return }
                self.subscriptions[token] = nil
            }
        }
    
        private let tokenGenerator = TokenGenerator()
        
        private var subscriptions = [TokenGenerator.TokenType: Subscription]() {
            didSet {
                if oldValue.isEmpty, !subscriptions.isEmpty, state == .idle {
                    state = .active
                }
            }
        }
        
        private var state: State = .idle {
            didSet {
                guard oldValue == .idle else { return TK.fallback() }
                onBecomeActive?()
            }
        }
    }
}


// MARK: - Auxiliary Types

extension TK.EventSender {
    
    typealias TokenGenerator = TK.UniqueTokenGenerator.Default
    
    private struct Subscription {
        let condition: (EventT) -> Bool
        let block: (EventT) -> Void
    }
    
    private enum State {
        case idle
        case active // has one or more subscriptions
    }
}
