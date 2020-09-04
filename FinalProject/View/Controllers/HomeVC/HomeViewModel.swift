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
    func getData() {
        for item in dummyData {
            if let collectorImage = CollectorImage(JSON: item) {
                collectorImages.append(collectorImage)
            }
        }
    }

    func cellForItem(atIndexPath indexPath: IndexPath) -> HomeCellViewModel {
        guard indexPath.row < collectorImages.count else { return HomeCellViewModel() }
        let collectorImage = collectorImages[indexPath.row]
        return HomeCellViewModel(collectorImage: collectorImage)
    }
}

let dummyData: [[String: Any]] = [
    ["title": "leather-jacket-1", "imageUrl": "https://i.pinimg.com/564x/2a/d0/62/2ad0623e84a4e0e9360a5bb206e3ec8b.jpg"],
    ["title": "leather-jacket-2", "imageUrl": "https://i.pinimg.com/564x/22/71/79/22717950c4944141950c5fe8f9dd4d44.jpg"],
    ["title": "leather-jacket-3", "imageUrl": "https://i.pinimg.com/564x/dd/50/1e/dd501e1c6c199d52fee738f63b3d6de7.jpg"],
    ["title": "leather-jacket-4", "imageUrl": "https://i.pinimg.com/564x/6e/8d/ea/6e8deabf10249872ab38501470458706.jpg"],
    ["title": "leather-jacket-1", "imageUrl": "https://i.pinimg.com/564x/2a/d0/62/2ad0623e84a4e0e9360a5bb206e3ec8b.jpg"],
    ["title": "leather-jacket-1", "imageUrl": "https://i.pinimg.com/564x/2a/d0/62/2ad0623e84a4e0e9360a5bb206e3ec8b.jpg"],
    ["title": "leather-jacket-2", "imageUrl": "https://i.pinimg.com/564x/22/71/79/22717950c4944141950c5fe8f9dd4d44.jpg"],
    ["title": "leather-jacket-3", "imageUrl": "https://i.pinimg.com/564x/dd/50/1e/dd501e1c6c199d52fee738f63b3d6de7.jpg"],
    ["title": "leather-jacket-4", "imageUrl": "https://i.pinimg.com/564x/6e/8d/ea/6e8deabf10249872ab38501470458706.jpg"],
    ["title": "leather-jacket-1", "imageUrl": "https://i.pinimg.com/564x/2a/d0/62/2ad0623e84a4e0e9360a5bb206e3ec8b.jpg"],
    ["title": "leather-jacket-1", "imageUrl": "https://i.pinimg.com/564x/2a/d0/62/2ad0623e84a4e0e9360a5bb206e3ec8b.jpg"],
    ["title": "leather-jacket-2", "imageUrl": "https://i.pinimg.com/564x/22/71/79/22717950c4944141950c5fe8f9dd4d44.jpg"],
    ["title": "leather-jacket-3", "imageUrl": "https://i.pinimg.com/564x/dd/50/1e/dd501e1c6c199d52fee738f63b3d6de7.jpg"],
    ["title": "leather-jacket-4", "imageUrl": "https://i.pinimg.com/564x/6e/8d/ea/6e8deabf10249872ab38501470458706.jpg"],
    ["title": "leather-jacket-1", "imageUrl": "https://i.pinimg.com/564x/2a/d0/62/2ad0623e84a4e0e9360a5bb206e3ec8b.jpg"],
    ["title": "leather-jacket-1", "imageUrl": "https://i.pinimg.com/564x/2a/d0/62/2ad0623e84a4e0e9360a5bb206e3ec8b.jpg"],
    ["title": "leather-jacket-2", "imageUrl": "https://i.pinimg.com/564x/22/71/79/22717950c4944141950c5fe8f9dd4d44.jpg"],
    ["title": "leather-jacket-3", "imageUrl": "https://i.pinimg.com/564x/dd/50/1e/dd501e1c6c199d52fee738f63b3d6de7.jpg"],
    ["title": "leather-jacket-4", "imageUrl": "https://i.pinimg.com/564x/6e/8d/ea/6e8deabf10249872ab38501470458706.jpg"],
    ["title": "leather-jacket-1", "imageUrl": "https://i.pinimg.com/564x/2a/d0/62/2ad0623e84a4e0e9360a5bb206e3ec8b.jpg"],
    ["title": "leather-jacket-1", "imageUrl": "https://i.pinimg.com/564x/2a/d0/62/2ad0623e84a4e0e9360a5bb206e3ec8b.jpg"],
    ["title": "leather-jacket-2", "imageUrl": "https://i.pinimg.com/564x/22/71/79/22717950c4944141950c5fe8f9dd4d44.jpg"],
    ["title": "leather-jacket-3", "imageUrl": "https://i.pinimg.com/564x/dd/50/1e/dd501e1c6c199d52fee738f63b3d6de7.jpg"],
    ["title": "leather-jacket-4", "imageUrl": "https://i.pinimg.com/564x/6e/8d/ea/6e8deabf10249872ab38501470458706.jpg"],
    ["title": "leather-jacket-1", "imageUrl": "https://i.pinimg.com/564x/2a/d0/62/2ad0623e84a4e0e9360a5bb206e3ec8b.jpg"],
    ["title": "leather-jacket-1", "imageUrl": "https://i.pinimg.com/564x/2a/d0/62/2ad0623e84a4e0e9360a5bb206e3ec8b.jpg"],
    ["title": "leather-jacket-2", "imageUrl": "https://i.pinimg.com/564x/22/71/79/22717950c4944141950c5fe8f9dd4d44.jpg"],
    ["title": "leather-jacket-3", "imageUrl": "https://i.pinimg.com/564x/dd/50/1e/dd501e1c6c199d52fee738f63b3d6de7.jpg"],
    ["title": "leather-jacket-4", "imageUrl": "https://i.pinimg.com/564x/6e/8d/ea/6e8deabf10249872ab38501470458706.jpg"],
    ["title": "leather-jacket-1", "imageUrl": "https://i.pinimg.com/564x/2a/d0/62/2ad0623e84a4e0e9360a5bb206e3ec8b.jpg"]
]
