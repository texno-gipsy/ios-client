//
//  AvatarCollectionModel.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import UIKit

final class AvatarCollectionModel {
    static let avatars = [
        0: UIImage(named: "purtov-avatar")!,
        1: UIImage(named: "sadovnikov-avatar")!,
        2: UIImage(named: "tkachenko-avatar")!,
        3: UIImage(named: "lebedev-avatar")!,
    ]

    func avatar(for userId: Int) -> UIImage {
        return Self.avatars[userId]!
    }
}
