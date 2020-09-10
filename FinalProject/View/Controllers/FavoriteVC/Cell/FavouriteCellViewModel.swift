//
//  FavouriteCellViewModel.swift
//  FinalProject
//
//  Created by hieungq on 8/30/20.
//  Copyright © 2020 Asiantech. All rights reserved.
//

import Foundation

final class FavouriteCellViewModel {
    // MARK: - Properties
    private(set) var collectorImage: CollectorImage?

    // MARK: - Function
    init(collectorImage: CollectorImage? = nil) {
        self.collectorImage = collectorImage
    }
}
