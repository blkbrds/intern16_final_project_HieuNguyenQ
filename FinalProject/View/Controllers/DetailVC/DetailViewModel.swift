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
    var selectedIndex: IndexPath?

    // MARK: - Functoin
    func cellForItemAt(indexPath: IndexPath) -> DetailCellViewModel {
        guard indexPath.row < collectorImages.count else { return DetailCellViewModel() }
        let collectorImage = collectorImages[indexPath.row]
        return DetailCellViewModel(collectorImage: collectorImage, selectedIndex: indexPath)
    }

    func getData(page: Int, limit: Int, completion: @escaping APICompletion) {
        Api.Home.getAllImages(atPage: page, withLimit: 20) { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .failure(let error):
                completion( .failure(error))
            case .success(let result):
                this.collectorImages.append(contentsOf: result)
                completion( .success)
            }
        }
    }
}
