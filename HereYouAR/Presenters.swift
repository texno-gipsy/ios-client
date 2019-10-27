//
//  BottomSheetPresenter.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import UIKit

class BottomSheetPresenter {

    typealias Transition<S> = (S, S)

    public enum State {
        case presented
        case dismissed
    }

    public func setState(_ state: State, animated: Bool = false, completion: ((State) -> ())? = nil) {
        let oldValue = self.state
        self.state = state
        self.completion = completion
        if animated {
            resolveAnimated(transition: (oldValue, state))
        }
        else {
            resolve(transition: (oldValue, state))
        }
    }

    private(set) var state: State = .dismissed
    private var completion: ((State) -> ())?

    var dimView: (UIVisualEffectView & TK.Dimmable.Slf)!
    var containerView: LayoutContainerView!
    var animator: UIViewPropertyAnimator!

    let contentView: TK.DefaultView
    let onView: TK.DefaultView

    init(view: TK.DefaultView, onView: TK.DefaultView) {
        self.contentView = view
        self.onView = onView

        setupViews()

        animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) {
            self.dimView.set(state: .active)
            self.contentView.transform = .identity
        }
        animator.pausesOnCompletion = true
    }

    func resolveAnimated(transition: Transition<State>) {
        switch transition {
        case (.dismissed, .presented):
            resolve(transition: transition)
            dimView.set(state: .inactive)
            contentView.transform = {
                let translation = CGAffineTransform(translationX: 0, y: 1000)
                let scale = CGAffineTransform(scaleX: 0.7, y: 0.7)
                return translation.concatenating(scale)
            }()
            animator.startAnimation()

        case (.presented, .dismissed):
            animateDismiss()

        default:
            resolve(transition: transition)
        }
    }

    func resolve(transition: Transition<State>) {
        switch transition {
        case (.dismissed, .presented):
            onView.addSubview(containerView)
            containerView.addSubview(dimView)
            containerView.addSubview(contentView)
            containerView.setNeedsUpdateConstraints()
            contentView.state = .active

        case (.presented, .dismissed):
            dimView.removeFromSuperview()
            contentView.removeFromSuperview()
            containerView.removeFromSuperview()
            contentView.state = .inactive
            completion?(.dismissed)

        default:
            assertionFailure()
        }
    }

    @objc func bgTapped() {
        animateDismiss()
    }

    func animateDismiss() {
        animator.isReversed = true
        animator.pausesOnCompletion = false
        animator.addCompletion { [weak self] (position) in
            guard let self = self else { return }
            self.resolve(transition: (.presented, .dismissed))
        }
        animator.startAnimation()
    }

    func setupViews() {
        containerView = makeContainerView()
        containerView.layoutMargins = .zero
        contentView.layer.cornerRadius = 16
        dimView = BottomSheetPresenter.makeRegularDimView()
        dimView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bgTapped)))
    }

    @objc func contentViewPanned(panGR: UIPanGestureRecognizer) {
        /// dpurtov-TODO: Implement correct pan behaviour
        switch panGR.state {
        case .began:
            animateDismiss()
        case .changed:
            break
        case .ended:
            break
        default:
            break
        }
    }
}


extension BottomSheetPresenter {

    func makeContainerView() -> LayoutContainerView {
        let view = LayoutContainerView() { [unowned self] in
            self.containerView.snp.updateConstraints {
                $0.edges.equalTo(0)
            }

            self.dimView.snp.updateConstraints {
                $0.edges.equalTo(0)
            }

            self.contentView.snp.remakeConstraints() {
                $0.bottom.equalTo(0)
                $0.leading.equalTo(20)
                $0.trailing.equalTo(-20)
            }
        }

        return view
    }

    static func makeRegularDimView() -> UIVisualEffectView & TK.Dimmable.Slf {
//        let view = UIView()
//        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        return view
        return UIVisualEffectView()
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
//            view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            UIView.animate(withDuration: 0.3, animations: {
                view.alpha = 1.0
//                view.transform = .identity
            }) { (_) in }

            return TK.Disposable.Base {
                [weak view] in
                guard let view = view else { return }
                view.alpha = 1.0
                UIView.animate(withDuration: 0.3, animations: {
                    view.alpha = 0.0
//                    view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                }) { _ in view.removeFromSuperview() }
            }
        }
    }
}


class LayoutContainerView: UIView {

    let updateConstraintsClosure: () -> ()

    init(updateConstraintsClosure: @escaping () -> ()) {
        self.updateConstraintsClosure = updateConstraintsClosure
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        TK.fatalError(.shouldNeverBeCalled(nil))
    }

    override func updateConstraints() {
        updateConstraintsClosure()
        super.updateConstraints()
    }

}
