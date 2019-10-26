//
//  EventCollectionModel.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import Foundation

final class EventCollectionModel {

    // Deps:
    lazy var apiClient = AppComponents.shared.coreComponents.apiClient

    let eventSender = TK.EventSender<ModelEvent>()
    enum ModelEvent {
        case dataUpdated
    }

    var events: [Event] = [] {
        didSet {
            eventSender.send(.dataUpdated)
        }
    }

    var fetchTask: FetchTask<Result<[Event], ApiClient.Error>>?

    func refresh() {
        guard fetchTask == nil else { return }
        let fetchTask = apiClient.fetchEvents()
        fetchTask.addCompletion { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let events):
                self.events = events
                print("""
                //=======================================================
                Fetched events:
                \(events)
                //=======================================================
                """)
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
