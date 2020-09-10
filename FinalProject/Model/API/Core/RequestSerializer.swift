//
//  App.swift
//  FinalProject
//
//  Created by Bien Le Q. on 8/26/19.
//  Copyright © 2019 Asiantech. All rights reserved.
//

import Foundation
import Alamofire

extension ApiManager {

    @discardableResult
    func request(method: HTTPMethod,
                 urlString: URLStringConvertible,
                 parameters: [String: Any]? = nil,
                 encoding: ParameterEncoding = URLEncoding.default,
                 headers: [String: String]? = nil,
                 completion: Completion<Any>?) -> Request? {
        guard Network.shared.isReachable else {
            completion?(.failure(Api.Error.network))
            return nil
        }

        var header = api.defaultHTTPHeaders
        header.updateValues(headers)

        let request = Alamofire.request(urlString.urlString,
                                        method: method,
                                        parameters: parameters,
                                        encoding: encoding,
                                        headers: header
            ).responseJSON { (response) in
                // Fix bug AW-4571: Call request one more time when see error 53 or -1_005
                if let error = response.error,
                    error.code == Api.Error.connectionAbort.code || error.code == Api.Error.connectionWasLost.code {
                    Alamofire.request(urlString.urlString,
                                      method: method,
                                      parameters: parameters,
                                      encoding: encoding,
                                      headers: header
                        ).responseJSON { response in
                            completion?(response.result)
                    }
                } else {
                    completion?(response.result)
                }
        }
        return request
    }

    func request(with urlString: String, headers: [String: String], dataImage: Data, completion: @escaping (Completion<Any>)) {
        guard let url = URL(string: urlString) else {
            let error = Api.Error.invalidURL
            completion(.failure(error))
            return
        }
        let base64Image = dataImage.base64EncodedString(options: .lineLength64Characters)

        let parameters = [
        [
            "key": "image",
            "value": "\(base64Image)",
            "type": "text"
        ],
        [
            "key": "album",
            "value": "T7DWwmQ",
            "type": "text"
        ],
        [
            "key": "description",
            "value": "T7DWwmQ",
            "type": "text"
        ]
            ] as [JSObject]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers

        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        for param in parameters {
            let paramKey = param["key"]
            let paramValue = param["value"]
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramKey ?? "")\""
            body += "\r\n\r\n\(paramValue ?? "")\r\n"
        }
        body += "--\(boundary)--\r\n"

        let postData = body.data(using: .utf8)
        request.httpBody = postData

        let config = URLSessionConfiguration.ephemeral
        config.waitsForConnectivity = true
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let session = URLSession(configuration: config)
        let tast = session.dataTask(with: request) { (data, _, _) in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(.failure(Api.Error.network))
                    return
                }
                let resultData = data.toJSON()
                completion(.success(resultData as Any))
            }
        }

        tast.resume()
    }

    func request(urlString: String, completion: @escaping (Completion<Any>)) {
        guard let url = URL(string: urlString) else {
            return
        }

        let config = URLSessionConfiguration.ephemeral
        config.waitsForConnectivity = true
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data, _, _) in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(.failure(Api.Error.network))
                    return
                }
                let resultData = data.toJSON()
                completion(.success(resultData as Any))
            }
        }
        dataTask.resume()
    }
}
