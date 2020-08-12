//
//  DetailCollectionViewCell.swift
//  FinalProject
//
//  Created by hieungq on 8/11/20.
//  Copyright © 2020 Asiantech. All rights reserved.
//

import UIKit
import Hero

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

    private func setupDetailImageView() {
        detailImageView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).withAlphaComponent(0.5)
        detailImageView.translatesAutoresizingMaskIntoConstraints = false
        if let imageHeight = viewModel.collectorImage?.heigthImage, let imageWidth = viewModel.collectorImage?.widthImage {
            imageHeightConstraint.constant = imageHeight * UIScreen.main.bounds.width / imageWidth
        }
        imageView.image = viewModel.collectorImage?.image
    }

    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        print("123")
    }
}
