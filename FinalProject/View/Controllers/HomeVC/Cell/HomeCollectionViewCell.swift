//
//  HomeCollectionViewCell.swift
//  theCollectors
//
//  Created by hieungq on 8/1/20.
//  Copyright © 2020 hieungq. All rights reserved.
//

import UIKit

final class HomeCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOulet
    @IBOutlet private(set) weak var imageView: UIImageView!

    // MARK: - Properties
    var viewModel: HomeCellViewModel = HomeCellViewModel() {
        didSet {
            updateView()
        }
    }

    // MARK: - Function
    private func updateView() {
        clipsToBounds = true
        layer.cornerRadius = 10
//        guard let collectorImage = viewModel.collectorImage else { return }
        imageView.image = #imageLiteral(resourceName: "1")
    }
}
