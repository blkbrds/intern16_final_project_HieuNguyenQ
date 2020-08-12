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
  //      guard let tabBar = tabBarController?.tabBar else { return }
        if tabBar.isHidden == hidden { return }
        let frameY = hidden ? tabBar.frame.size.height + tabBar.frame.size.height : -tabBar.frame.size.height - tabBar.frame.size.height
        tabBar.isHidden = false

        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut, animations: {
            self.tabBar.frame = self.tabBar.frame.offsetBy(dx: 0, dy: frameY)
        }, completion: { (_) in
            self.tabBar.isHidden = hidden
        })
    }
}
