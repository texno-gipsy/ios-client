//
//  Entities.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import Foundation

struct User {
    let id: Int
    let name: String
}

struct Event {
    let id: Int
    let longitude: Double
    let latitude: Double
    let title: String
    let type: EventType
    let description: String?
    let tags: [Tag]?
    let startDate: Date?
    let endDate: Date?
    let participantsLimit: Int?
    let participantIds: [Int]?
    let score: Double?
}

enum EventType: String {
    case place = "place"
    case event = "event"
}

struct Tag: Hashable {
    let name: String
}

