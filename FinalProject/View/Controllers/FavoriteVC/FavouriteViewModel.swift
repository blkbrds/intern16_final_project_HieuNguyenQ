//
//  FavouriteViewModel.swift
//  FinalProject
//
//  Created by hieungq on 8/30/20.
//  Copyright © 2020 Asiantech. All rights reserved.
//

import RealmSwift

protocol FavouriteViewModelDelegate: class {
    func viewModel(_ viewModel: FavouriteViewModel)
}

final class FavouriteViewModel {
    // MARK: - Properties
    private(set) var collectorImages: [CollectorImage] = []
    private var notificationToken: NotificationToken?
    weak var delegate: FavouriteViewModelDelegate?

    // MARK: - Function
    func getData(completion: @escaping Completion<Any>) {
        do {
            collectorImages.removeAll()
            let realm = try Realm()
            let images = realm.objects(CollectorImage.self).sorted(byKeyPath: "dateAppend", ascending: false)
            for item in images {
                let image = CollectorImage()
                image.imageID = item.imageID
                image.imageUrl = item.imageUrl
                image.heigthImage = CGFloat(item.heigthImageForRealm)
                image.widthImage = CGFloat(item.widthImageForRealm)
                image.albumID = item.albumID
                collectorImages.append(image)
            }
            completion(.success(true))
        } catch {
            HUD.showError(withStatus: App.String.Error.errorSomeThingWrong)
        }
    }

    func cellForItem(atIndexPath indexPath: IndexPath) -> FavouriteCellViewModel {
        guard indexPath.row < collectorImages.count else { return FavouriteCellViewModel() }
        let collectorImage = collectorImages[indexPath.row]
        return FavouriteCellViewModel(collectorImage: collectorImage)
    }

    func getDetailViewModel(forIndexPath indexPath: IndexPath) -> DetailViewModel {
        let detailVM = DetailViewModel()
        detailVM.collectorImages = collectorImages
        detailVM.selectedIndexPath = indexPath
        return detailVM
    }

    func setupObserve() {
        do {
            let realm = try Realm()
            notificationToken = realm.objects(CollectorImage.self).observe({ (_) in
                self.delegate?.viewModel(self)
            })
        } catch {
            HUD.showError(withStatus: App.String.Error.errorSomeThingWrong)
        }
    }
}
