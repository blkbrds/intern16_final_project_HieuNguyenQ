//
//  CollectorImage.swift
//  FinalProject
//
//  Created by hieungq on 8/4/20.
//  Copyright © 2020 Asiantech. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import RealmSwift

final class CollectorImage: Object, Mappable {
    @objc dynamic var imageID: String = ""
    @objc dynamic var imageUrl: String = ""
    @objc dynamic var widthImageForRealm: Double = 0
    @objc dynamic var heigthImageForRealm: Double = 0
    @objc dynamic var dateAppend: Date = Date()
    @objc dynamic var albumID: String = ""
    var widthImage: CGFloat = 0
    var heigthImage: CGFloat = 0
    var image: UIImage?

    required convenience init?(map: Map) {
        self.init()
    }

    override class func primaryKey() -> String {
        return "imageID"
    }

    func mapping(map: Map) {
        imageID <- map["id"]
        imageUrl <- map["link"]
        widthImage <- map["width"]
        heigthImage <- map["height"]
        albumID <- map["description"]
    }
}
