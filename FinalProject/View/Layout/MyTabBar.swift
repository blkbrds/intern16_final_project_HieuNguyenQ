//
//  MyTabBar.swift
//  FinalProject
//
//  Created by hieungq on 8/31/20.
//  Copyright © 2020 Asiantech. All rights reserved.
//

import UIKit

var centerButton: UIButton?

extension UITabBar {
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if let centerButton = centerButton {
          if centerButton.frame.contains(point) {
            return true
          }
        }

        return self.bounds.contains(point)
    }
}
