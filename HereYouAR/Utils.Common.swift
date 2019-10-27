//
//  Utils.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import UIKit
import RxSwift

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
    typealias DefaultView = View<CALayer>

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

        var state: State = .inactive
        public enum State {
            case inactive
            case activating
            case active
            case deactivating
        }
    }
}

extension TK {
    class TitleView: DefaultView {
        var titleLabel: UILabel!

        init() {
            super.init(frame: .zero)

            setupSubviews()
        }

        func setupSubviews() {
            titleLabel = UILabel()
            titleLabel.font = Resources.Fonts.museoSans900(24)
            addSubview(titleLabel)

            setNeedsUpdateConstraints()
        }

        override func updateConstraints() {
            layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            titleLabel.snp.updateConstraints {
                $0.edges.equalTo(layoutMarginsGuide)
            }
            super.updateConstraints()
        }
    }
}

extension TK {
    class FancyView: DefaultView {
        var containerView: UIView!
        var titleView: TitleView!
        var stackView: UIStackView!
        var actionButton: UIButton!

        let disposeBag = DisposeBag()

        var onAction: (() -> Void)?

        init() {
            super.init(frame: .zero)

            setupSubviews()
        }

        func setupSubviews() {
            stackView = UIStackView()
            stackView.spacing = 8.0
            stackView.axis = .vertical
            stackView.alignment = .fill
            addSubview(stackView)

            titleView = TK.TitleView()
            titleView.isHidden = true
            stackView.addArrangedSubview(titleView)

            containerView = UIView()
            stackView.addArrangedSubview(containerView)

            actionButton = UIButton(type: .system)
            actionButton.titleLabel?.font = Resources.Fonts.museoSans900(24.0)
            actionButton.layer.cornerRadius = 8.0
            actionButton.setTitleColor(.black, for: .normal)
            actionButton.backgroundColor = Resources.Colors.accentColor
            actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
            actionButton.isHidden = true
            actionButton.animateWhenPressed(disposeBag: disposeBag)
            stackView.addArrangedSubview(actionButton)

            setNeedsUpdateConstraints()
        }

        override func updateConstraints() {
            layoutMargins = .zero

            actionButton.snp.updateConstraints {
                $0.leading.trailing.equalTo(containerView.layoutMarginsGuide)
                $0.height.equalTo(40)
            }

            stackView.snp.updateConstraints {
                $0.edges.equalTo(layoutMarginsGuide)
            }
            super.updateConstraints()
        }

        @objc func actionButtonTapped() {
            onAction!()
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
