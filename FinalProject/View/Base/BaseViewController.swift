//
//  BaseViewController.swift
//  theCollectors
//
//  Created by hieungq on 7/30/20.
//  Copyright © 2020 hieungq. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
    }

    // MARK: - Function
    func setupUI() {
        view.backgroundColor = .black
    }

    func setupNavigationBar() { }
}
