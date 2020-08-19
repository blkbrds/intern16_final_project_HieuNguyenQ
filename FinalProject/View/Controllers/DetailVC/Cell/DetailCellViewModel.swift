//
//  DetailCellViewModel.swift
//  FinalProject
//
//  Created by hieungq on 8/11/20.
//  Copyright © 2020 Asiantech. All rights reserved.
//
import UIKit

final class DetailCellViewModel {

    private(set) var collectorImage: CollectorImage?
    private(set) var selectedIndex: IndexPath?
    private(set) var collectorImageSimilars: [CollectorImage] = []

    init(collectorImage: CollectorImage? = nil, selectedIndex: IndexPath? = nil) {
        self.collectorImage = collectorImage
        self.selectedIndex = selectedIndex
    }

    func getDataSimilar(completion: @escaping Completion<Any>) {
        Api.CollectorImages.getAllImages(atPage: 0, withLimit: 20) { (result) in
            switch result {
            case .failure(let error):
                completion( .failure(error))
            case .success(let result):
                self.collectorImageSimilars.append(contentsOf: result)
                self.collectorImageSimilars.shuffle()
                completion( .success(true))
            }
        }
    }

    func cellForItemAt(indexPath: IndexPath) -> SimilarCellViewModel {
        guard indexPath.row < collectorImageSimilars.count else { return SimilarCellViewModel() }
        let collectorImage = collectorImageSimilars[indexPath.row]
        return SimilarCellViewModel(collectorImage: collectorImage)
    }
}
