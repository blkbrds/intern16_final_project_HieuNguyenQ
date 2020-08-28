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

        func getUrlForAlbum(forAlbumID albumID: String) -> String {
            let queryParams: String = "/\(albumID)"
            return Api.Path.baseURL + Api.Path.album + queryParams
        }

        func uploadImage() -> String {
            return Api.Path.baseURL + Api.Path.uploadImage
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
                        if images.count > 0 {
                            images.shuffle()
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

    static func getAllImagesSimilar(albumID: String, completion: @escaping Completion<[CollectorImage]>) {
        let urlString = QueryString().getUrlForAlbum(forAlbumID: albumID)
        api.request(method: .get, urlString: urlString, parameters: .none, encoding: URLEncoding.default, headers: Api.Path.header) { (result) in
            switch result {
            case .success(let data):
                if let data = data as? [String: Any] {
                    if let data = data["data"] as? [String: Any] {
                        if let imageData = data["images"] as? [[String: Any]] {
                            var images: [CollectorImage] = []
                            for item in imageData {
                                if let image = CollectorImage(JSON: item) {
                                    images.append(image)
                                }
                            }
                            if images.count > 0 {
                                images.shuffle()
                            }
                            completion(.success(images))
                        }
                    }
                } else {
                    completion( .failure(Api.Error.emptyData))
                }
            case .failure(let error):
                completion( .failure(error))
            }
        }
    }

    static func uploadImage(dataImage: Data, completion: @escaping Completion<CollectorImage>) {
        let urlString = QueryString().uploadImage()
        api.request(with: urlString, headers: Api.Path.header, dataImage: dataImage) { (result) in
            switch result {
            case .success(let data):
                if let data = data as? [String: Any] {
                    if let data = data["data"] as? [String: Any] {
                        if let image = CollectorImage(JSON: data) {
                            image.image = UIImage(data: dataImage)
                            completion(.success(image))                            
                        }
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
