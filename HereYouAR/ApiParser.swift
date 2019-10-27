//
//  ApiParser.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import Foundation
import SwiftyJSON

class ApiParser {

    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()

    func parse(_ json: JSON) -> User? {
        guard let id = json["id"].int else { return TK.fallback(nil) }
        guard let name = json["name"].string else { return TK.fallback(nil) }
        let tags = json["tags"].array?.compactMap { parse($0) } as [Tag]?
        return User(id: id, name: name, instagramURL: nil, tags: tags)
    }

    func parse(_ json: JSON) -> [User]? {
        return json.arrayValue.compactMap { self.parse($0) }
    }

    func parse(_ json: JSON) -> Tag? {
        guard let name = json.string else { return TK.fallback(nil) }
        return Tag(name: name)
    }

    func parse(_ json: JSON) -> Event? {
        guard let id = json["id"].int else { return TK.fallback(nil) }
        guard let longitude = json["lon"].double else { return TK.fallback(nil) }
        guard let latitude = json["lat"].double else { return TK.fallback(nil) }
        guard let title = json["title"].string else { return TK.fallback(nil) }
        guard let typeStr = json["type"].string, let type = EventType(rawValue: typeStr) else { return TK.fallback(nil) }
        let description = json["description"].string
        let tags = json["tags"].array?.compactMap { parse($0) } as [Tag]?
        let startDate = parseDate(json["start_at"])
        let endDate = parseDate(json["end_at"])
        let participantsLimit = json["limit"].int
        let participantIds = json["participants_ids"].array?.compactMap { $0.int }
        let score = json["score"].double

        return Event(
            id: id,
            longitude: longitude,
            latitude: latitude,
            title: title,
            type: type,
            description: description,
            tags: tags,
            startDate: startDate,
            endDate: endDate,
            participantsLimit: participantsLimit,
            participantIds: participantIds,
            score: score)
    }

    func parse(_ json: JSON) -> [Event]? {
        return json.arrayValue.compactMap { self.parse($0) }
    }

    func parseDate(_ json: JSON) -> Date? {
        return json.string.flatMap { dateFormatter.date(from: $0) }
    }
}
