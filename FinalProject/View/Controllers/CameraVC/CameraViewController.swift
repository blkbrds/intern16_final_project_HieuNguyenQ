//
//  CategoryViewController.swift
//  theCollectors
//
//  Created by hieungq on 7/27/20.
//  Copyright © 2020 hieungq. All rights reserved.
//

import UIKit

final class CameraViewController: BaseViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var shotButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var rollButton: UIButton!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
    }

    override func setupUI() {
        view.backgroundColor = .black
    }

    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        print("Back")
    }

    @IBAction func shotButtonTouchUpInside(_ sender: Any) {
        print("Take a picture")
        print("Done")
        flashButton.isHidden = true
        shotButton.isHidden = true
        rollButton.isHidden = true
        uploadButton.isHidden = false
    }
}
