//
//  EventSearchModel.swift
//  HereYouAR
//
//  Created by Anton Lebedev on 27.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import NaturalLanguage


final class EventSearchModel {
    let compaundTags: Set<Tag> = Set(["food", "cinema", "sport", "travel", "walk", "music", "exhibitions", "parties"].map{ Tag(name:$0) })
    
    let eventCollectionModel: EventCollectionModel
    let tagCollectionModel: TagCollectionModel
    let wordEmbeding: NLEmbedding
    
    init(eventCollectionModel: EventCollectionModel, tagCollectionModel:TagCollectionModel) {
        self.eventCollectionModel = eventCollectionModel
        self.tagCollectionModel = tagCollectionModel
        self.wordEmbeding = NLEmbedding.wordEmbedding(for: .english)!
    }
    
    func calculateTagDistance(tag1: Tag, tag2: Tag) -> Double{
        return wordEmbeding.distance(between: tag1.name.lowercased(), and: tag2.name.lowercased())
    }
    
    func getEvents(minLongitude: Double,
                   maxLongitude: Double,
                   minLatitude: Double,
                   maxLattitude: Double) -> [Event] {
        var filteredEvents: [Event] = []
        for event in eventCollectionModel.events {
            if event.latitude < minLatitude || event.latitude > maxLattitude {
                continue
            }
            if event.longitude < minLongitude || event.longitude > maxLongitude {
                continue
            }
            filteredEvents.append(event)
        }
        return filteredEvents;
    }
    
    func getEventsByTag(tag: Tag,
                        minLongitude: Double,
                        maxLongitude: Double,
                        minLatitude: Double,
                        maxLattitude: Double,
                        eventsNum: Int) -> [Event] {
        let allEvents = getEvents(minLongitude: minLongitude,
                                  maxLongitude: maxLongitude,
                                  minLatitude: minLatitude,
                                  maxLattitude: maxLattitude)
        
        let sortedEvents = allEvents.sorted(by: {event1, event2 in
            guard let tags1 = event1.tags else {return false}
            guard let tags2 = event1.tags else {return true}
            let scores1 = tags1.map {calculateTagDistance(tag1:$0, tag2:tag)}
            let scores2 = tags2.map {calculateTagDistance(tag1:$0, tag2:tag)}
            guard let score1 = scores1.min() else {return false}
            guard let score2 = scores2.min() else {return true}
            return score1 < score2
        })
        
        var filteredEvents: [Event] = []
        var pointer = 0
        while filteredEvents.count < eventsNum && pointer < sortedEvents.count {
            filteredEvents.append(sortedEvents[pointer])
            pointer += 1
        }
        return filteredEvents
        
    }
    
    
    
}
