//
//  App.swift
//  FinalProject
//
//  Created by Bien Le Q. on 8/26/19.
//  Copyright © 2019 Asiantech. All rights reserved.
//

import Foundation
import Alamofire

final class Api {

    struct Path {
        static let baseURL = "https://api.imgur.com/3"

        static let allImages = "/account/me/images"
        static let allAlbums = "/account/hieunguyen8794/albums"
        static let album = "/album"
        static let uploadImage = "/image"

        static let header = ["Authorization": "Bearer a3dec8319d0d2de84b0dc6ef6d3f922608e7dd5f"]
    }

    struct CollectorImages { }
}

protocol URLStringConvertible {
    var urlString: String { get }
}

protocol ApiPath: URLStringConvertible {
    static var path: String { get }
}

private func / (lhs: URLStringConvertible, rhs: URLStringConvertible) -> String {
    return lhs.urlString + "/" + rhs.urlString
}

extension String: URLStringConvertible {
    var urlString: String { return self }
}

private func / (left: String, right: Int) -> String {
    return left.appending(path: "\(right)")
}
