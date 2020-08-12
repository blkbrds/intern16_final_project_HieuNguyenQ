//
//  DetailViewModel.swift
//  FinalProject
//
//  Created by hieungq on 8/11/20.
//  Copyright © 2020 Asiantech. All rights reserved.
//

import UIKit
import Alamofire

final class DetailViewModel {
    // MARK: - Properties
    var collectorImages: [CollectorImage] = []

    // MARK: - Functoin
    func cellForItemAt(indexPath: IndexPath) -> DetailCellViewModel {
        guard indexPath.row < collectorImages.count else { return DetailCellViewModel() }
        let collectorImage = collectorImages[indexPath.row]
        return DetailCellViewModel(collectorImage: collectorImage)
    }

    // get image nil frome collectorImages
    func getData(selectedIndex: Int, limit: Int, completion: @escaping Completion<Any>) {
        // if all collectorImage in array with empty image and imageThumbnail
        for i in selectedIndex..<collectorImages.count {
            if collectorImages[i].image == nil {
                Alamofire.request(collectorImages[i].imageUrl).responseData { (response) in
                    if let data = response.result.value {
                        self.collectorImages[i].image = UIImage(data: data)
                    } else {
                        self.collectorImages[i].image = nil
                    }
                }
            }
        }
        // else data is good, then loadmore data at page
//        let page: Int = collectorImages.count / 20 + 1
//        Api.CollectorImages.getAllImages(atPage: page, withLimit: 20) { (result) in
//            switch result {
//            case .failure(let error):
//                completion( .failure(error))
//            case .success(let result):
//                self.collectorImages.append(contentsOf: result)
//                completion( .success(true))
//            }
//        }
    }
}
