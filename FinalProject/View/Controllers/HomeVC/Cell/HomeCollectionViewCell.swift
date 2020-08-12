//
//  HomeCollectionViewCell.swift
//  theCollectors
//
//  Created by hieungq on 8/1/20.
//  Copyright © 2020 hieungq. All rights reserved.
//

import UIKit
import Alamofire

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
