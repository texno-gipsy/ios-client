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
        case tagsUpdated
        case selectedTagsUpdated
    }

    var sortedTags: [Tag] {
        return tags.sorted { $0.name < $1.name }
    }

    var tags: Set<Tag> = [] {
        didSet {
            eventSender.send(.tagsUpdated)
        }
    }

    init(eventCollectionModel: EventCollectionModel) {
        self.eventCollectionModel = eventCollectionModel
        eventSubscription = eventCollectionModel.eventSender.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.tags = Set(self.eventCollectionModel.eventStubs.flatMap { $0.tags ?? [] })
//            self.tags = Set(self.stubTags)
        }.scoped()
    }

    var fetchTask: FetchTask<Result<[Event], ApiClient.Error>>?

    func refresh() {
        eventCollectionModel.refresh()
    }

//    lazy var predefinedTags = {
//
//    }

    private lazy var stubTags = {
        ["music", "sport", "theater", "football", "basketball", "exhibitionism", "bar-hopping", "singing", "volleyball", "polo", "cricket"].map { Tag(name: $0) }
    }()
//    private lazy var stubTags = {
//        ["music"].map { Tag(name: $0) }
//    }()

    var selectedTags = Set<Tag>()

    func set(tag: Tag, selected: Bool) {
        if selected {
            selectedTags.insert(tag)
        }
        else {
            selectedTags.remove(tag)
        }
        eventSender.send(.selectedTagsUpdated)
    }
}
