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
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var previewCamera: UIView!
    @IBOutlet weak var imageView: UIImageView!

    // MARK: - Properties
    let cameraController = CameraController()
    var dataImage: Data?
    var viewModel = CameraViewModel()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCameraController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.changeTabBar(hidden: true)
        if let captureSession = cameraController.captureSession {
            captureSession.startRunning()
        }
    }

    // MARK: - Function
    override func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }

    override func setupUI() {
        view.backgroundColor = .black
    }

    func configureCameraController() {
        cameraController.prepare { (error) in
            if let error = error {
                print(error)
            }

            try? self.cameraController.displayPreview(onView: self.previewCamera)
        }
    }

    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        if imageView.isHidden == false {
            imageView.isHidden = true
            uploadButton.isHidden = true

            flashButton.isHidden = false
            shotButton.isHidden = false
            switchCameraButton.isHidden = false

            cameraController.captureSession?.startRunning()
        } else {
            cameraController.captureSession?.stopRunning()
            tabBarController?.selectedIndex = 0
            guard let tabBarSubview = tabBarController?.tabBar.subviews else { return }
            for button in tabBarSubview {
                if let centerButton = button as? UIButton {
                    centerButton.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                }
            }
        }
    }

    @IBAction func shotButtonTouchUpInside(_ sender: Any) {
        cameraController.captureImage { (image, error) in
            if let image = image {
                self.dataImage = image.jpegData(compressionQuality: 0.3)
                self.imageView.image = image
                self.imageView.isHidden = false
                self.imageView.contentMode = .scaleAspectFill
                self.cameraController.captureSession?.stopRunning()
            } else {
                print(error ?? "")
            }
        }
        flashButton.isHidden = true
        shotButton.isHidden = true
        switchCameraButton.isHidden = true
        uploadButton.isHidden = false
        uploadButton.isEnabled = true
    }
    @IBAction func flashButtonTouchUpInside(_ sender: Any) {
        if cameraController.flashMode == .off {
            cameraController.flashMode = .on
            flashButton.setImage(#imageLiteral(resourceName: "Flash Off Icon"), for: .normal)
        } else {
            cameraController.flashMode = .off
            flashButton.setImage(#imageLiteral(resourceName: "Flash On Icon"), for: .normal)
        }
    }

    @IBAction func switchCameraButtonTouchUpInside(_ sender: Any) {
        do {
            try cameraController.switchCameras()
        } catch {
            print(error)
        }

        switch cameraController.currentCameraPosition {
        case .front:
            switchCameraButton.setImage(#imageLiteral(resourceName: "Rear Camera Icon"), for: .normal)
        case .rear:
            switchCameraButton.setImage(#imageLiteral(resourceName: "Front Camera Icon"), for: .normal)
        case .none:
            return
        }
    }

    @IBAction func uploadButtonTouchUpInside(_ sender: Any) {
        uploadButton.isEnabled = false
        guard let dataImage = dataImage else { return }
        Api.CollectorImages.uploadImage(dataImage: dataImage) { (result) in
            switch result {
            case .failure(let error):
                print(error.errorsString)
            case .success(let result):
                print(result)
                self.viewModel.collectorImages.append(result)
                let detailViewController = DetailViewController()
                detailViewController.viewModel = self.viewModel.getDetailViewModel()
                self.navigationController?.hero.isEnabled = true
                self.navigationController?.heroNavigationAnimationType = .none
                self.navigationController?.pushViewController(detailViewController, animated: true)
                self.imageView.isHidden = true
                self.uploadButton.isHidden = true
                self.flashButton.isHidden = false
                self.shotButton.isHidden = false
                self.switchCameraButton.isHidden = false
            }
        }
    }
}
