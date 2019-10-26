//
//  MainMapView.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import UIKit
import SnapKit
import MapKit

class MainMapView: TK.View<CALayer> {
    var mapView: MKMapView!

    init() {
        super.init(frame: .zero)

        backgroundColor = .white

        setupSubviews()
    }

    func setupSubviews() {
        mapView = MKMapView()
        addSubview(mapView)

        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        mapView.snp.updateConstraints {
            $0.edges.equalTo(layoutMarginsGuide)
        }

        super.updateConstraints()
    }
}

