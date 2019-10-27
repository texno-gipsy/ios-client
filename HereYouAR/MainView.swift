//
//  MainView.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import UIKit
import SnapKit
import MapKit

class MainView: TK.DefaultView {

    // Deps:
    lazy var profileModel = AppComponents.shared.coreComponents.profileModel
    lazy var eventCollectionModel = AppComponents.shared.coreComponents.eventCollectionModel
    
    lazy var styler = AppComponents.shared.uiComponents.styler

    var onUserViewTap: (() -> Void)!

    var mapView: MapView!
    var userView: UserView!
    var addEventButton: AddEventButton!

    init() {
        super.init(frame: .zero)

        backgroundColor = .white

        setupSubviews()
        setupBindings()
    }

    func setupSubviews() {
        mapView = MapView()
        addSubview(mapView)

        addEventButton = AddEventButton()
        addSubview(addEventButton)

        userView = UserView()

        userView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(userViewTapped))
        styler.applyMapStyle(to: userView)
        userView.addGestureRecognizer(tapGR)
        addSubview(userView)

        setNeedsUpdateConstraints()
    }

    @objc func userViewTapped() {
        onUserViewTap()
    }

    func setupBindings() {
        eventCollectionModel.refresh()
        addEventButton.action = {}
        userView.user = profileModel.user
    }

    override func updateConstraints() {
        layoutMargins = .zero
        mapView.snp.updateConstraints {
            $0.edges.equalTo(0)
        }

        addEventButton.snp.updateConstraints {
            $0.centerX.equalTo(layoutMarginsGuide.snp.centerX)
            $0.bottom.equalTo(layoutMarginsGuide)
        }

        userView.snp.updateConstraints {
            $0.top.trailing.equalTo(layoutMarginsGuide)
        }

        super.updateConstraints()
    }

//    func showAccessories(completion: @escaping () -> Void = {}) -> TK.Disposable.Base {
//        addSubview(view)
//        view.snp.remakeConstraints {
//            $0.edges.equalTo(0)
//        }
//        parentView.setNeedsLayout()
//        parentView.layoutIfNeeded()
//        completion()
//
//        view.alpha = 0.0
//        view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
//        UIView.animate(withDuration: 0.3, animations: {
//            view.alpha = 1.0
//            view.transform = .identity
//        }) { (_) in }
//
//        return TK.Disposable.Base {
//            [weak view] in
//            guard let view = view else { return }
//            view.alpha = 1.0
//            UIView.animate(withDuration: 0.3, animations: {
//                view.alpha = 0.0
//                view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
//            }) { _ in view.removeFromSuperview() }
//        }
//    }
}
