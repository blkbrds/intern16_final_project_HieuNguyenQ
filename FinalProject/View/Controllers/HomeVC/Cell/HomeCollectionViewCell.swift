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
        clipsToBounds = true
        layer.cornerRadius = 10
        let itemCollector = viewModel.collectorImage
        if itemCollector?.image != nil {
            self.imageView.image = itemCollector?.image
        } else {
            if let imageUrl = itemCollector?.imageUrl {
                Alamofire.request(imageUrl).responseData { (response) in
                    if let data = response.result.value {
                        self.imageView.image = UIImage(data: data)
                        itemCollector?.image = UIImage(data: data)
                    } else {
                        itemCollector?.image = nil
                    }
                }
            }
        }
    }
}
