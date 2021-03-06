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

    var loginView: LoginView?
    var mainView: MainView?
    var profileView: ProfileView?
    var eventView: EventView?
    var mapView: MapView?

    var bottomSheetPresenter: BottomSheetPresenter?

    init(coreComponents: CoreComponents, uiComponents: UIComponents) {
        self.coreComponents = coreComponents
        self.uiComponents = uiComponents
    }

    func startApp() {
        window = UIWindow(frame: UIScreen.main.bounds)
        rootVC = uiComponents.rootVC
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        showLoginView()
    }

    func showLoginView() {
        loginView = uiComponents.loginView

        let presenter = TK.Presenter()
        let disposable = presenter.show(view: loginView!, on: rootVC!.view)

        loginView?.onLoginComplete = { [weak self] in
            guard let self = self else { return }
            disposable.dispose()
            self.showMainView()
        }
    }

    func showMainView() {
        mainView = uiComponents.mainView
        mainView?.onUserViewTap = { [weak self] in
            guard let self = self else { return }
            self.showProfileView()
        }
        
        mapView = mainView?.mapView
        mapView?.onEventTap = { [weak self] in
            guard let self = self else { return }
            self.showEventView()
        }
       

        let presenter = TK.Presenter()
        _ = presenter.show(view: mainView!, on: rootVC!.view)
    }

    func showProfileView() {
        profileView = uiComponents.profileView
        profileView?.onAction = { [weak self] in
            guard let self = self else { return }
            self.hideFromBottomSheet(self.profileView!)
        }
        showInBottomSheet(profileView!)
    }
    
    func showEventView() {
        eventView = mapView?.eventView
        showInBottomSheet(eventView!)
    }

    func showInBottomSheet(_ view: TK.DefaultView) {
        guard bottomSheetPresenter == nil else {
            assertionFailure()
            return
        }

        let bottomSheetPresenter = BottomSheetPresenter(view: view, onView: mainView!)
        bottomSheetPresenter.setState(.presented, animated: true) { [weak self] state in
            guard let self = self else { return }
            guard state == .dismissed else { return }
            self.bottomSheetPresenter = nil
        }
        self.bottomSheetPresenter = bottomSheetPresenter
    }

    func hideFromBottomSheet(_ view: TK.DefaultView) {
        guard let bottomSheetPresenter = bottomSheetPresenter else { return TK.fallback() }
        guard bottomSheetPresenter.contentView === view else { return TK.fallback() }

        bottomSheetPresenter.setState(.dismissed, animated: true) { [weak self] (state) in
            guard let self = self else { return }
            guard state == .dismissed else { return }
            self.bottomSheetPresenter = nil
        }
    }
}
