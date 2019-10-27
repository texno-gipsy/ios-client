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

    var events: [Event] = [
        Event(id: 1001, longitude: 37.575535, latitude: 55.815375, title: "Moscow Hack", type: .event, description: "Hackathon", tags: [Tag(name: "hackathon")], startDate: nil, endDate: nil, participantsLimit: 500, participantIds: nil, score: nil),
        Event(id: 1002, longitude: 37.530753, latitude: 55.703107, title: "MSU mafia", type: .event, description: "Mafia game in MSU", tags: [Tag(name: "mafia"), Tag(name: "game")], startDate: nil, endDate: nil, participantsLimit: 10, participantIds: nil, score: nil),
        Event(id: 1003, longitude: 37.575410, latitude: 55.757487, title: "Football", type: .event, description: "Playing Football in the garden", tags: [Tag(name: "football"), Tag(name: "game")], startDate: nil, endDate: nil, participantsLimit: 10, participantIds: nil, score: nil),
        Event(id: 1004, longitude: 37.609891, latitude: 55.741661, title: "Shisha smoking", type: .event, description: "Smoke shisha tonight at red october", tags: [Tag(name: "shisha"), Tag(name: "chill"), Tag(name: "launge")], startDate: nil, endDate: nil, participantsLimit: 2, participantIds: nil, score: nil),
        Event(id: 1005, longitude: 37.5747451, latitude: 55.759755, title: "Watch movie", type: .event, description: "Watch a new film in solovey", tags: [Tag(name: "cinema"), Tag(name: "movie")], startDate: nil, endDate: nil, participantsLimit: 5, participantIds: nil, score: nil),
        Event(id: 1006, longitude:37.574718, latitude: 55.815236, title: "Cookies", type: .event, description: "Eat some cookies on snack point", tags: [Tag(name: "food"), Tag(name: "hackathon")], startDate: nil, endDate: nil, participantsLimit: 5, participantIds: nil, score: nil),
        ]
        {
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
                self.events.append(contentsOf: events)
                print("""
                //=======================================================
                Fetched events:
                \(self.events)
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
