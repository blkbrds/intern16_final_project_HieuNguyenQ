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
                    var array: [CollectorImage] = Mapper<CollectorImage>().mapArray(JSONArray: imageDatas)
                    if array.count > 0 { array = array.shuffled() }
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

extension Api.Detail {
    static func getAllImagesSimilar(albumID: String, completion: @escaping Completion<[CollectorImage]>) {
        let urlString = Api.Path.Detail(albumID: albumID).album
        api.request(method: .get, urlString: urlString, headers: Api.Path.header) { (result) in
            switch result {
            case .success(let data):
                if let data = data as? JSObject, let data2 = data["data"] as? JSObject, let imageDatas = data2["images"] as? JSArray {
                    var array: [CollectorImage] = Mapper<CollectorImage>().mapArray(JSONArray: imageDatas)
                    if array.count > 0 { array = array.shuffled() }
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

extension Api.Camera {
    static func uploadImage(dataImage: Data, completion: @escaping Completion<CollectorImage>) {
        let urlString = Api.Path.Camera().upload
        api.request(with: urlString, headers: Api.Path.header, dataImage: dataImage) { (result) in
            switch result {
            case .success(let data):
                if let data = data as? JSObject, let data2 = data["data"] as? JSObject {
                    if let image: CollectorImage = Mapper<CollectorImage>().map(JSON: data2) {
                        image.image = UIImage(data: dataImage)
                        completion(.success(image))
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
