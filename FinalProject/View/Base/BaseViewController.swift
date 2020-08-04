//
//  BaseViewController.swift
//  theCollectors
//
//  Created by hieungq on 7/30/20.
//  Copyright © 2020 hieungq. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Properties
    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "backgroundImage")
        imageView.contentMode = .scaleAspectFill
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        return imageView
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setupUI()
    }

    // MARK: - Function
    func setupUI() {
        view.insertSubview(backgroundImage, at: 0)
    }

    func setupTitle() { }
}
