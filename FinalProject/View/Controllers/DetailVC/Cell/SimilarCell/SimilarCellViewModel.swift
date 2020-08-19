//
//  SimilarCellViewModel.swift
//  FinalProject
//
//  Created by hieungq on 8/19/20.
//  Copyright © 2020 Asiantech. All rights reserved.
//

import UIKit

final class SimilarCellViewModel {
    private(set) var collectorImage: CollectorImage?

    init(collectorImage: CollectorImage? = nil) {
        self.collectorImage = collectorImage
    }
}
