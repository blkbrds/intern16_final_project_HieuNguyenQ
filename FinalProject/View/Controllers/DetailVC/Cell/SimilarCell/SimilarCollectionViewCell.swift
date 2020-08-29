//
//  SimilarCollectionViewCell.swift
//  FinalProject
//
//  Created by hieungq on 8/19/20.
//  Copyright © 2020 Asiantech. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class SimilarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    var viewModel: SimilarCellViewModel = SimilarCellViewModel() {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        imageView.backgroundColor = #colorLiteral(red: 0.2589701414, green: 0.2645449936, blue: 0.2916174233, alpha: 1).withAlphaComponent(0.3)
        let itemCollector = viewModel.collectorImage

        if let imageUrl = itemCollector?.imageUrl {
            imageView.sd_imageTransition = .fade
            let imageUrl = URL(string: imageUrl)
            imageView.sd_setImage(with: imageUrl, placeholderImage: nil, options: SDWebImageOptions.highPriority, context: [.imageThumbnailPixelSize: CGSize(width: 320, height: 320)])
        }
    }
}
