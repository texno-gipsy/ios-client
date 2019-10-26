//
//  ProfileModel.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import Foundation

struct UserCredentials {
    let id: Int
}

final class ProfileModel {

    // Deps:
    lazy var apiClient = AppComponents.shared.coreComponents.apiClient
    lazy var userCollectionModel = AppComponents.shared.coreComponents.userCollectionModel

    var user: User?
    var credentials: UserCredentials?

    func login(credentials: UserCredentials) {
        self.credentials = credentials
        user = userCollectionModel.user(id: credentials.id)
    }
}
