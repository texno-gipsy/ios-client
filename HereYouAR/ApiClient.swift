//
//  ApiClient.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ApiClient {
    let baseURL = URL(string: "https://texno-gipsy.herokuapp.com")!
    let parser: ApiParser

    var profileModel: ProfileModel!

    init() {
        parser = ApiParser()
    }

    func combinedURLString(path: String) -> String {
        baseURL.appendingPathComponent("api/client/v1/\(path)").absoluteString
    }

    func fetchUsers() -> FetchTask<Result<[User], Error>> {
        return request(
            method: .get,
            urlString: combinedURLString(path: "users"),
            params: [:],
            encoding: Alamofire.URLEncoding(),
            headers: [:]) {
                return self.parser.parse($0)
            }
    }

    func fetchEvents() -> FetchTask<Result<[Event], Error>> {
        return request(
            method: .get,
            urlString: combinedURLString(path: "events"),
            params: [:],
            encoding: Alamofire.URLEncoding(),
            headers: [:]) {
                return self.parser.parse($0)
            }
    }

    func request<EntityT>(
        method: Alamofire.HTTPMethod,
        urlString: String,
        params: Alamofire.Parameters,
        encoding: Alamofire.ParameterEncoding,
        headers: Alamofire.HTTPHeaders,
        parser: @escaping (JSON) -> EntityT?) -> FetchTask<Result<EntityT, Error>> {
        return FetchTask<Result<EntityT, Error>>(
            fetch: { [weak self] fullfill in
                var newEncoding = encoding
                if method == .post {
                    newEncoding = Alamofire.JSONEncoding()
                }

                let request = AF.request(
                    urlString,
                    method: method,
                    parameters: params,
                    encoding: newEncoding,
                    headers: headers)

                return request.response { // [weak self]
                    dataResponse in
//                    guard let self = self else { return }

                    guard let httpResponse = dataResponse.response else {
                        fullfill(.failure(.unknown))
                        return
                    }

                    if httpResponse.statusCode / 100 != 2 {
                        fullfill(.failure(.unknown))
                    }

                    guard let data = dataResponse.data else {
                        fullfill(.failure(.unknown))
                        return
                    }

                    guard let json = try? JSON(data: data) else {
                        fullfill(.failure(.unknown))
                        return
                    }

                    let jsonData = json["data"]
                    guard jsonData.type != .null else {
                        fullfill(.failure(.unknown))
                        return
                    }

                    guard let entity = parser(jsonData) else {
                        fullfill(.failure(.unknown))
                        return
                    }

                    fullfill(.success(entity))
                }
            },
            cancel: { ($0 as? DataRequest)?.cancel() })
    }
}

extension ApiClient {
    enum Error: Swift.Error {
        case unknown
    }
}
