//
//  UIComponents.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import Foundation

class UIComponents {
    let coreComponents: CoreComponents

    init(coreComponents: CoreComponents) {
        self.coreComponents = coreComponents
    }

    lazy var rootVC = RootViewController()
    lazy var mainView = MainView()
    lazy var loginView = LoginView()
    lazy var profileView = ProfileView()

    lazy var styler = UIStyler()
}
