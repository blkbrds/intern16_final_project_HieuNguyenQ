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

final class CollectorImage: Mappable {
    var imageID: String = ""
    var imageUrl: String = ""
    var image: UIImage?
    var imageThumbnail: UIImage?
    var widthImage: CGFloat = 0
    var heigthImage: CGFloat = 0
    var albumID: String = ""
    
    init?(map: Map) { }

    func mapping(map: Map) {
        imageID <- map["id"]
        imageUrl <- map["link"]
        widthImage <- map["width"]
        heigthImage <- map["height"]
        albumID <- map["description"]
    }
}
