//
//  HomeViewModel.swift
//  theCollectors
//
//  Created by hieungq on 8/1/20.
//  Copyright © 2020 hieungq. All rights reserved.
//

import Foundation

final class HomeViewModel {

    // MARK: - Properties
    private(set) var collectorImages: [CollectorImage] = []

    // MARK: - Function
    func getData(atPage page: Int, withLimit perPage: Int, completion: @escaping Completion<Any>) {
        Api.CollectorImages.getAllImages(atPage: page, withLimit: perPage) { (result) in
            switch result {
            case .failure(let error):
                completion( .failure(error))
            case .success(let result):
                self.collectorImages.append(contentsOf: result)
                completion( .success(true))
            }
        }
    }

    func cellForItem(atIndexPath indexPath: IndexPath) -> HomeCellViewModel {
        guard indexPath.row < collectorImages.count else { return HomeCellViewModel() }
        let collectorImage = collectorImages[indexPath.row]
        return HomeCellViewModel(collectorImage: collectorImage)
    }
}
