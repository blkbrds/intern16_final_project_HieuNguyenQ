//
//  CameraViewModel.swift
//  FinalProject
//
//  Created by hieungq on 8/27/20.
//  Copyright © 2020 Asiantech. All rights reserved.
//

import UIKit

final class CameraViewModel {

    // MARK: - Properties
    var collectorImages: [CollectorImage] = []

    func getDetailViewModel() -> DetailViewModel {
        let detailVM = DetailViewModel()
        detailVM.collectorImages = collectorImages
        return detailVM
    }
}
