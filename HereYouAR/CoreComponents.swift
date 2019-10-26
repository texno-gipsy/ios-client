//
//  CoreComponents.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import Foundation

class CoreComponents {
    let apiClient: ApiClient
    let profileModel: ProfileModel
    let userCollectionModel: UserCollectionModel
    let eventCollectionModel: EventCollectionModel

    init() {
        apiClient = ApiClient()
        profileModel = ProfileModel(apiClient: apiClient)
        userCollectionModel = UserCollectionModel(apiClient: apiClient)
        eventCollectionModel = EventCollectionModel(apiClient: apiClient)
    }
}
