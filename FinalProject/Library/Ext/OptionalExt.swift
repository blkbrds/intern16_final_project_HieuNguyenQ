//
//  OptionalExt.swift
//  FinalProject
//
//  Created by hieungq on 9/4/20.
//  Copyright © 2020 Asiantech. All rights reserved.
//

import UIKit

extension Optional where Wrapped == String {
    var content: String {
        guard let str = self else { return "" }
        return str
    }
}

extension Optional where Wrapped == CGFloat {
    var unwrapped: CGFloat {
        guard let str = self else { return CGFloat() }
        return str
    }
}
