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

    func getDataSimilar(completion: @escaping APICompletion) {
        Api.Detail.getAllImagesSimilar(albumID: (collectorImage?.albumID).content) { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .failure(let error):
                completion( .failure(error))
            case .success(var result):
                for i in 0..<result.count where this.collectorImage?.imageID == result[i].imageID {
                    result.remove(at: i)
                    break
                }
                this.collectorImageSimilars.append(contentsOf: result)
                completion( .success)
            }
        }
    }

    func cellForItemAt(indexPath: IndexPath) -> SimilarCellViewModel {
        guard indexPath.row < collectorImageSimilars.count else { return SimilarCellViewModel() }
        let collectorImage = collectorImageSimilars[indexPath.row]
        return SimilarCellViewModel(collectorImage: collectorImage)
    }

    func getDetailViewModel(forIndexPath indexPath: IndexPath) -> DetailViewModel {
        let detailVM = DetailViewModel()
        detailVM.collectorImages = collectorImageSimilars
        detailVM.selectedIndex = indexPath
        return detailVM
    }
}
