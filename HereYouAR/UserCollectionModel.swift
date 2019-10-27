//
//  UserCollectionModel.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import Foundation
import RxSwift

final class UserCollectionModel {

    // Deps:
    lazy var apiClient = AppComponents.shared.coreComponents.apiClient

    let eventSender = TK.EventSender<ModelEvent>()
    enum ModelEvent {
        case dataUpdated
    }

    var usersWithCredentials: [User] {
        return users.filter {
            let ids = Set([1, 2, 3, 4])
            return ids.contains($0.id)
        }
    }

    var users: [User] = [] {
        didSet {
            eventSender.send(.dataUpdated)
        }
    }

    func user(id: Int) -> User? {
        return users.first(where: { $0.id == id })
    }

    var fetchTask: FetchTask<Result<[User], ApiClient.Error>>?

    func refresh() {
        guard fetchTask == nil else { return }
        let fetchTask = apiClient.fetchUsers()
        fetchTask.addCompletion { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                self.users = users
                self.fetchTask = nil
            case .failure(let error):
                print("""
                =======================
                Error: \(error)
                =======================
                """)
                self.fetchTask = nil
            }
        }
        fetchTask.start()
        self.fetchTask = fetchTask
    }
}
