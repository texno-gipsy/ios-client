//
//  AppController.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import UIKit

final class AppController {
    var window: UIWindow!
    let coreComponents: CoreComponents
    let uiComponents: UIComponents

    var rootVC: RootViewController?
    var mainMapView: MainMapView?

    init(coreComponents: CoreComponents, uiComponents: UIComponents) {
        self.coreComponents = coreComponents
        self.uiComponents = uiComponents
    }

    func startApp() {
        window = UIWindow(frame: UIScreen.main.bounds)
        rootVC = uiComponents.rootVC
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
    }

    func showMainMapView() {
        mainMapView = uiComponents.mainMapView

        let presenter = TK.Presenter()
        _ = presenter.show(view: mainMapView!, on: rootVC!.view)
    }
}
