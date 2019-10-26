//
//  AppComponents.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import Foundation

final class AppComponents {
    static let shared = { AppComponents() }

    let coreComponents: CoreComponents
    let uiComponents: UIComponents

    init() {
        coreComponents = CoreComponents()
        uiComponents = UIComponents(coreComponents: coreComponents)
    }
}
