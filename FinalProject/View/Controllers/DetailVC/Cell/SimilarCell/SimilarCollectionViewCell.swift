//
//  SimilarCollectionViewCell.swift
//  FinalProject
//
//  Created by hieungq on 8/19/20.
//  Copyright © 2020 Asiantech. All rights reserved.
//

import UIKit
import Alamofire

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
        if itemCollector?.imageThumbnail != nil {
            self.imageView.image = itemCollector?.imageThumbnail
        } else {
            self.imageView.image = nil
            if let imageUrl = itemCollector?.imageUrl, let imageID = itemCollector?.imageID {
                let imageUrlForThumbnail = imageUrl.replacingOccurrences(of: imageID, with: String(imageID + "m"))
                Alamofire.request(imageUrlForThumbnail).responseData { (response) in
                    if let data = response.result.value {
                        let image = UIImage(data: data)
                        self.imageView.image = image
                        itemCollector?.imageThumbnail = image
                    } else {
                        itemCollector?.imageThumbnail = nil
                    }
                }
                Alamofire.request(imageUrl).responseData { (response) in
                    if let data = response.result.value {
                        itemCollector?.image = UIImage(data: data)
                    } else {
                        itemCollector?.image = nil
                    }
                }
            }
        }
    }
}