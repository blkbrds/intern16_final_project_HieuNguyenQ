//
//  DetailCellViewModel.swift
//  FinalProject
//
//  Created by hieungq on 8/11/20.
//  Copyright © 2020 Asiantech. All rights reserved.
//

final class DetailCellViewModel {

    private(set) var collectorImage: CollectorImage?

    init(collectorImage: CollectorImage? = nil) {
        self.collectorImage = collectorImage
    }
}
