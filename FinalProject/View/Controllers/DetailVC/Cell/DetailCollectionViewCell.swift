//
//  DetailCollectionViewCell.swift
//  FinalProject
//
//  Created by hieungq on 8/11/20.
//  Copyright © 2020 Asiantech. All rights reserved.
//

import UIKit
import Hero
import Alamofire

protocol CollectionViewCellDelegate: class {
    func showAleart(_ alertError: Error?)
}

class DetailCollectionViewCell: UICollectionViewCell {

    // MARK: - Constriant
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!

    // MARK: - IBOutlet
    @IBOutlet weak var detailImageView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!

    // MARK: - Properties
    var viewModel: DetailCellViewModel = DetailCellViewModel() {
        didSet {
            setupDetailImageView()
        }
    }
    var actionBlock = { }
    weak var delegate: CollectionViewCellDelegate?

    // MARK: - Function
    private func setupDetailImageView() {
        detailImageView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).withAlphaComponent(0.5)
        detailImageView.translatesAutoresizingMaskIntoConstraints = false
        if let imageHeight = viewModel.collectorImage?.heigthImage, let imageWidth = viewModel.collectorImage?.widthImage {
            imageHeightConstraint.constant = imageHeight * UIScreen.main.bounds.width / imageWidth
        }
        if viewModel.collectorImage?.image != nil {
            imageView.image = viewModel.collectorImage?.image
        } else {
            if let imageUrl = viewModel.collectorImage?.imageUrl {
              Alamofire.request(imageUrl).responseData { (response) in
                    if let data = response.result.value {
                        self.viewModel.collectorImage?.image = UIImage(data: data)
                        self.imageView.image = UIImage(data: data)
                    } else {
                        self.viewModel.collectorImage?.image = nil
                    }
                }
            }
        }
    }

    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        actionBlock()
    }

    @IBAction func likeButtonTouchUpInside(_ sender: Any) {

    }

    @IBAction func saveButtonTouchUpInside(_ sender: Any) {
        guard let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        delegate?.showAleart(error)
    }
}
