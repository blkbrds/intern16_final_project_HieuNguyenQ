//
//  HomeViewModel.swift
//  theCollectors
//
//  Created by hieungq on 8/1/20.
//  Copyright © 2020 hieungq. All rights reserved.
//

import UIKit

final class HomeViewModel {

    // MARK: - Properties
    private(set) var collectorImages: [CollectorImage] = []

    // MARK: - Function
    func getData(atPage page: Int, withLimit perPage: Int, completion: @escaping APICompletion) {
        Api.Home.getAllImages(atPage: page, withLimit: perPage) { (result) in
            switch result {
            case .failure(let error):
                completion( .failure(error))
            case .success(let result):
                self.collectorImages.append(contentsOf: result)
                completion( .success)
            }
        }
    }

    func cellForItem(atIndexPath indexPath: IndexPath) -> HomeCellViewModel {
        guard indexPath.row < collectorImages.count else { return HomeCellViewModel() }
        let collectorImage = collectorImages[indexPath.row]
        return HomeCellViewModel(collectorImage: collectorImage)
    }

    func getDetailViewModel(forIndexPath indexPath: IndexPath) -> DetailViewModel {
        let detailVM = DetailViewModel()
        detailVM.collectorImages = collectorImages
        detailVM.selectedIndex = indexPath
        return detailVM
    }

    func sizeOfImageAtIndexPath(atIndexPath indexPath: IndexPath) -> CGSize {
        guard indexPath.row < collectorImages.count else { return CGSize() }
        let collectorImage = collectorImages[indexPath.row]
        return CGSize(width: collectorImage.widthImage, height: collectorImage.heigthImage)
    }
}
