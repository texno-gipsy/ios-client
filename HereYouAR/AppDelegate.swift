//
//  AppDelegate.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        

        window = UIWindow(frame: UIScreen.main.bounds)
        let rootVC = RootVC()
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()

        return true
    }

}

