//
//  API.Collector.swift
//  FinalProject
//
//  Created by hieungq on 8/5/20.
//  Copyright © 2020 Asiantech. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

extension Api.CollectorImages {
    struct QueryString {
        func getUrlForAllImages(atPage page: Int, withLimit perPage: Int) -> String {
            let queryParamns: String = "/?perPage=\(perPage)&page=\(page)"
            return Api.Path.baseURL + Api.Path.allImages + queryParamns
        }
    }

    static func getAllImages(atPage page: Int, withLimit perPage: Int, completion: @escaping Completion<[CollectorImage]>) {
        let urlString = QueryString().getUrlForAllImages(atPage: page, withLimit: perPage)
        api.request(method: .get, urlString: urlString, parameters: .none, encoding: URLEncoding.default, headers: Api.Path.header) { (result) in
            switch result {
            case .success(let data):
                if let data = data as? [String: Any] {
                    if let imageData = data["data"] as? [[String: Any]] {
                        var images: [CollectorImage] = []
                        for item in imageData {
                            if let image = CollectorImage(JSON: item) {
                                images.append(image)
                            }
                        }
                        completion(.success(images))
                    }
                } else {
                    completion( .failure(Api.Error.emptyData))
                }
            case .failure(let error):
                completion( .failure(error))
            }
        }
    }
}
