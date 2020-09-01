//
//  MyTabBar.swift
//  FinalProject
//
//  Created by hieungq on 8/31/20.
//  Copyright © 2020 Asiantech. All rights reserved.
//

import UIKit

class MyTabBar: UITabBar {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }
        return nil
    }
}
