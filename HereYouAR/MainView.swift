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
    var tagListView: TagListView!
    var userView: UserView!
    var addEventButton: AddEventButton!
    var geoCentrationButton: GeoCentrationButton!

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
        geoCentrationButton = GeoCentrationButton()
        addSubview(addEventButton)
        addSubview(geoCentrationButton)

        tagListView = TagListView()
        addSubview(tagListView)

        userView = UserView()
        userView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        userView.nameLabel.isHidden = true
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
        geoCentrationButton.action = mapView.setCenterToCurrentPosition
        userView.user = profileModel.user
    }

    override func updateConstraints() {
        layoutMargins = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        mapView.snp.updateConstraints {
            $0.edges.equalTo(0)
        }

        tagListView.snp.updateConstraints {
            $0.top.leading.trailing.equalTo(layoutMarginsGuide)
        }

        addEventButton.snp.updateConstraints {
            $0.centerX.equalTo(layoutMarginsGuide.snp.centerX)
            $0.bottom.equalTo(layoutMarginsGuide)
        }
        
        geoCentrationButton.snp.updateConstraints {
            $0.trailing.equalTo(layoutMarginsGuide.snp.trailing).offset(-30)
            $0.bottom.equalTo(layoutMarginsGuide).offset(-27)
        }

        userView.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        userView.snp.updateConstraints {
            $0.trailing.equalTo(0)
            $0.centerY.equalTo(addEventButton)
        }

        super.updateConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        userView.layer.cornerRadius = userView.bounds.size.width * 0.5
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
