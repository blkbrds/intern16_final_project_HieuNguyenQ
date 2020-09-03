//
//  CameraViewModel.swift
//  FinalProject
//
//  Created by hieungq on 8/27/20.
//  Copyright © 2020 Asiantech. All rights reserved.
//

import UIKit

class CameraViewModel {

    // MARK: - Properties
    var collectorImage = CollectorImage()

    func getDetailViewModel() -> DetailViewModel {
        let detailVM = DetailViewModel()
        detailVM.collectorImages.append(collectorImage)
        return detailVM
    }

    func uploadImage(dataImage: Data, completion: @escaping APICompletion) {
        Api.Camera.uploadImage(dataImage: dataImage) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                self.collectorImage = data
                completion(.success)
            }
        }
    }
}
