//
//  HomeCollectionViewCell.swift
//  theCollectors
//
//  Created by hieungq on 8/1/20.
//  Copyright © 2020 hieungq. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

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
        imageView.backgroundColor = #colorLiteral(red: 0.2589701414, green: 0.2645449936, blue: 0.2916174233, alpha: 1).withAlphaComponent(0.3)
        let itemCollector = viewModel.collectorImage

        if let imageUrl = itemCollector?.imageUrl {
            imageView.sd_imageTransition = .fade
            let imageUrl = URL(string: imageUrl)
            imageView.sd_setImage(with: imageUrl, placeholderImage: nil, options: SDWebImageOptions.highPriority, context: [.imageThumbnailPixelSize: Config.thumbnailSize])
        }
    }
}

// MARK: - Config
extension HomeCollectionViewCell {
    struct Config {
        static var thumbnailSize = CGSize(width: 320, height: 320)
    }
}
