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
    let tagCollectionModel: TagCollectionModel
    let avatarCollectionModel: AvatarCollectionModel

    init() {
        apiClient = ApiClient()
        profileModel = ProfileModel()
        apiClient.profileModel = profileModel

        userCollectionModel = UserCollectionModel()
        eventCollectionModel = EventCollectionModel()
        tagCollectionModel = TagCollectionModel(eventCollectionModel: eventCollectionModel)

        avatarCollectionModel = AvatarCollectionModel()
    }
}
