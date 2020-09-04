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

extension Api.Home {
    static func getAllImages(atPage page: Int, withLimit perPage: Int, completion: @escaping Completion<[CollectorImage]>) {
        let urlString = Api.Path.Home(page: page, limit: perPage).allImages
        api.request(method: .get, urlString: urlString, headers: Api.Path.header) { (result) in
            switch result {
            case .success(let data):
                if let data = data as? JSObject, let imageDatas = data["data"] as? JSArray {
                    let array: [CollectorImage] = Mapper<CollectorImage>().mapArray(JSONArray: imageDatas)
                    completion(.success(array))
                } else {
                    completion( .failure(Api.Error.emptyData))
                }
            case .failure(let error):
                completion( .failure(error))
            }
        }
    }
}
