//
//  Extensions.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import RxSwift
import RxCocoa

extension UIButton {

    func animateWhenPressed(disposeBag: DisposeBag) {
        let pressDownTransform = rx.controlEvent([.touchDown, .touchDragEnter])
            .map({ CGAffineTransform.identity.scaledBy(x: 0.85, y: 0.85) })

        let pressUpTransform = rx.controlEvent([.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
            .map({ CGAffineTransform.identity })

        Observable.merge(pressDownTransform, pressUpTransform)
            .distinctUntilChanged()
            .subscribe(onNext: animate(_:))
            .disposed(by: disposeBag)
    }

    private func animate(_ transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: {
                        self.transform = transform
            }, completion: nil)
    }
}


extension UIView {

//    func animateWhenPressed(disposeBag: DisposeBag, pressHandler) {
//        let tapGR = UITapGestureRecognizer()
//        tapGR.rx.event.dis
//        addGestureRecognizer(tapGR)
//
//        let pressDownTransform = rx.controlEvent([.touchDown, .touchDragEnter])
//            .map({ CGAffineTransform.identity.scaledBy(x: 0.85, y: 0.85) })
//
//        let pressUpTransform = rx.controlEvent([.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
//            .map({ CGAffineTransform.identity })
//
//        Observable.merge(pressDownTransform, pressUpTransform)
//            .distinctUntilChanged()
//            .subscribe(onNext: animate(_:))
//            .disposed(by: disposeBag)
//    }
//
//    private func animate(_ transform: CGAffineTransform) {
//        UIView.animate(withDuration: 0.4,
//                       delay: 0,
//                       usingSpringWithDamping: 0.5,
//                       initialSpringVelocity: 3,
//                       options: [.curveEaseInOut, .allowUserInteraction, .autoreverse, .repeat],
//                       animations: {
//                        self.transform = transform
//            }, completion: nil)
//    }

}

