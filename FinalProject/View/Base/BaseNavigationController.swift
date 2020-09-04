//
//  BaseNavigationController.swift
//  theCollectors
//
//  Created by hieungq on 7/30/20.
//  Copyright © 2020 hieungq. All rights reserved.
//

import UIKit
import Hero

class BaseNavigationController: UINavigationController {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }

    // MARK: - Functin
    private func setupNavigation() {
        navigationBar.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        navigationBar.barTintColor = #colorLiteral(red: 0.1577239037, green: 0.1681370437, blue: 0.1926085055, alpha: 1)
//        navigationBar.layer.masksToBounds = true
//        navigationBar.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
//        navigationBar.layer.cornerRadius = 15
    }
}
