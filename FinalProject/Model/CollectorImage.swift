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
    var title: String = ""
    var imageUrl: String = ""

    init?(map: Map) { }

    func mapping(map: Map) {
        title <- map["title"]
        imageUrl <- map["link"]
    }
}
