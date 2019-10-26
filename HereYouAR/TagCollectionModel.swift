//
//  TagCollectionModel.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import Foundation

final class TagCollectionModel {

    // Deps:
    let eventCollectionModel: EventCollectionModel
    var eventSubscription: TK.Disposable.Scoped?

    let eventSender = TK.EventSender<ModelEvent>()
    enum ModelEvent {
        case dataUpdated
    }

    var tags: Set<Tag> = [] {
        didSet {
            eventSender.send(.dataUpdated)
        }
    }

    init(eventCollectionModel: EventCollectionModel) {
        self.eventCollectionModel = eventCollectionModel
        eventSubscription = eventCollectionModel.eventSender.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.tags = Set(self.eventCollectionModel.events.flatMap { $0.tags ?? [] })
        }.scoped()
    }

    var fetchTask: FetchTask<Result<[Event], ApiClient.Error>>?

    func refresh() {
        eventCollectionModel.refresh()
    }
}
