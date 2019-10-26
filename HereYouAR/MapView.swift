//
//  MapView.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import UIKit
import NMAKit

let credentials = (
    appId: "yyIVPKAg05ZuUX8ytYLt",
    appCode: "Ti3_-uXldEjdZoPCY7AL2g",
    licenseKey: "BBqrrSHWcUzUhkQOgeTM5Wx+V24a48vHHz9zmXgA5wwbpLttD4uP/6QgCmxIXyk82Jg02ZyAbJdcFSB2sV1ozizDri1nV6OOGLUVrURTDMRrKnnRw7UY1oHFEaNG2SyZ/ESkdnhUgXqvMzLVWfu2FyFFkj0bdht7XrPR25bR9Wyk7SCDiSLfcf2sE7Tlb+D52O0z5GSk9fiOdYzRM9sxVCF6k3iqtHfHVe9Qcr6DtR25Zdp0fXyBTwoxBKflP7TfqZTL1WYsBTLzGBxZHZbuHDM8Xd46hcX4ayLABToE3yfFsBsqBskU8ggaj2ltmEEzyP+mG+JBSHZTNB44QBWUFx15fJUFPe4Zri+kQ4ID3/etoFfj1bfJAjk/DkavnsFzQPzVW8mybfIs21k31WDmnLdHewkzScftT3a7o1bca5cg3SrXdDzqIL5thNOfJ6aLN5eAy/6TQDnlEA6C6j+TnLKDgKVqnEKB1gH4FUgH4aqa3B8eNsl3GvyZa+43TMpNVnxGOXMZD8GSt4ef8IeMGymorpZY6sa14iXU0VIZ08quVQH1R8H5MJOSyL/Uv4Ih4C11xI85vV3+1vv5SsfYICXh3KgvvjfUl67XMGsfJm8vizb+uytEPlX6x3CcpKO4/xCjiuP1IMAYfHlK3JH3ddUpQdAgy9IgNWxpbL+XDFY="
)


class MapView: TK.View<CALayer> {

    // Deps:

    var mapView: NMAMapView!
    
    var currentLattitude: Double = 0
    var currentLongitude: Double = 0

    init() {
        super.init(frame: .zero)

        NMAApplicationContext.setAppId(credentials.appId, appCode: credentials.appCode, licenseKey: credentials.licenseKey)

        setupSubviews()
        setupBindings()
    }

    func setupSubviews() {
        mapView = NMAMapView()
        addSubview(mapView)

        setNeedsUpdateConstraints()
    }
    
    func setCenterToCurrentPosition() {
        let geoCoodCenter = NMAGeoCoordinates(latitude: currentLattitude,
                                              longitude: currentLongitude)
        mapView.set(geoCenter: geoCoodCenter, animation: .none)
    }
    
    @objc func didUpdatePosition() {
        guard let position = NMAPositioningManager.sharedInstance().currentPosition else {
            return
        }
        
        guard let coordinates = position.coordinates else {
            return
        }
        
        let distanceScore = abs(coordinates.latitude - currentLattitude) + abs(coordinates.longitude - currentLongitude)
        
        currentLattitude = coordinates.latitude
        currentLongitude = coordinates.longitude
        
        if distanceScore < 0.1 {
            return
        }
        
        setCenterToCurrentPosition()
        
    }

    func setupBindings() {
        NMAPositioningManager.sharedInstance().dataSource = NMAHEREPositionSource()

        let geoCoodCenter = NMAGeoCoordinates(latitude: currentLattitude,
                                              longitude: currentLongitude)
        mapView.set(geoCenter: geoCoodCenter, animation: .none)
        mapView.copyrightLogoPosition = .center

        // Set zoom level
        mapView.zoomLevel = NMAMapViewMaximumZoomLevel - 1

        // Subscribe to position updates
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didUpdatePosition),
                                               name: NSNotification.Name.NMAPositioningManagerDidUpdatePosition,
                                               object: NMAPositioningManager.sharedInstance())

        // Set position indicator visible. Also starts position updates.
        mapView.positionIndicator.isVisible = true
    }

    override func updateConstraints() {
        layoutMargins = .zero
        mapView.snp.updateConstraints {
            $0.edges.equalTo(0)
        }

        super.updateConstraints()
    }
}
