//
//  Utils.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import UIKit

enum TK {}

extension TK {
    enum TerminateReason {
        case notImplementedYet
        case shouldNeverBeCalled(_ message: String?)

        var message: String {
            switch self {
            case .notImplementedYet:
                return "Not implemented yet"
            case .shouldNeverBeCalled(let message):
                return "Should never be called" + {
                    guard let message = message else { return "" }
                    return ": " + message
                    }()
            }
        }
    }

    static func fatalError(_ reason: TerminateReason) -> Never {
        Swift.fatalError(reason.message)
    }

    static func fallback() {
        assertionFailure()
    }

    static func fallback<ValueT>(_ value: ValueT) -> ValueT {
        assertionFailure()
        return value
    }
}

extension TK {
    class View<LayerT>: UIView where LayerT: CALayer {
        override init(frame: CGRect) {
            super.init(frame: frame)
        }

        @available(*, unavailable)
        required init?(coder aDecoder: NSCoder) {
            TK.fatalError(.shouldNeverBeCalled("init?(coder:) not supported"))
        }

        override class var layerClass: AnyClass {
            return LayerT.self
        }

        var customLayer: LayerT {
            return self.layer as! LayerT
        }
    }
}


extension TK {
    class Presenter {
        func show(view: UIView, on parentView: UIView, completion: @escaping () -> Void = {}) -> TK.Disposable.Base {
//            guard let parentView = parentView ?? UIApplication.shared.keyWindow else {
//                return TK.fallback(TK.Disposable.Base())
//            }

            parentView.addSubview(view)
            view.snp.remakeConstraints {
                $0.edges.equalTo(0)
            }
            parentView.setNeedsLayout()
            parentView.layoutIfNeeded()
            completion()

            view.alpha = 0.0
            view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            UIView.animate(withDuration: 0.3, animations: {
                view.alpha = 1.0
                view.transform = .identity
            }) { (_) in }

            return TK.Disposable.Base {
                [weak view] in
                guard let view = view else { return }
                view.alpha = 1.0
                UIView.animate(withDuration: 0.3, animations: {
                    view.alpha = 0.0
                    view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                }) { _ in view.removeFromSuperview() }
            }
        }
    }
}

extension TK {
    enum Disposable {}
}

protocol _TKDisposable {
    func dispose()
}
extension TK.Disposable { typealias Slf = _TKDisposable }

extension TK.Disposable.Slf {

    func scoped() -> TK.Disposable.Scoped {
        return TK.Disposable.Scoped(self)
    }
}


extension TK.Disposable {

    class Base: TK.Disposable.Slf {

        private let disposeClosure: () -> ()

        init(_ dispose: @escaping () -> () = {}) {
            disposeClosure = dispose
        }

        func dispose() {
            disposeClosure()
        }
    }

    final class Scoped: Base {

        convenience init(_ disposable: TK.Disposable.Slf) {
            self.init {
                disposable.dispose()
            }
        }

        deinit {
            dispose()
        }

        func scoped() -> Scoped {
            return self
        }
    }
}
