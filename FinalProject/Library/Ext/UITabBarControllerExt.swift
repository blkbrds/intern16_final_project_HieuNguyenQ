//
//  UITabBarControllerExt.swift
//  FinalProject
//
//  Created by hieungq on 8/11/20.
//  Copyright © 2020 Asiantech. All rights reserved.
//

import UIKit

extension UITabBarController {
    func changeTabBar(hidden: Bool) {
        if tabBar.isHidden == hidden { return }
        let frameY = hidden ? tabBar.frame.size.height + tabBar.frame.size.height : -tabBar.frame.size.height - tabBar.frame.size.height
        let alpha: CGFloat = hidden ? 0 : 1
        tabBar.isHidden = false

        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
//            self.tabBar.frame = self.tabBar.frame.offsetBy(dx: 0, dy: frameY)
            self.tabBar.alpha = alpha
        }, completion: { (_) in
            self.tabBar.isHidden = hidden
        })
    }
}

