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
    func parseEvent(_ json: JSON) -> Event? {
        guard let id = json["id"].int else { return TK.fallback(nil) }
        guard let name = json["name"].string else { return TK.fallback(nil) }
        return Event(id: id, name: name)
    }

    func parseEvents(_ json: JSON) -> [Event]? {
        guard let data = json["data"].array else { return TK.fallback(nil) }
        return data.compactMap { self.parseEvent($0) }
//        guard let json["data"].string else { return TK.fallback(nil) }
    }
}
