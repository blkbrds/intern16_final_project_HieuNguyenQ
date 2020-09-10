//
//  DetailCellViewModel.swift
//  FinalProject
//
//  Created by hieungq on 8/11/20.
//  Copyright © 2020 Asiantech. All rights reserved.
//
import UIKit
import Hero
import RealmSwift

protocol DetailCellViewModelDelegate: class {
    func viewModel(_ viewModel: DetailCellViewModel)
}

final class DetailCellViewModel {

    // MARK: - Properties
    private(set) var collectorImage: CollectorImage?
    private(set) var selectedIndex: IndexPath?
    private(set) var collectorImageSimilars: [CollectorImage] = []
    private var notificationToken: NotificationToken?
    weak var delegate: DetailCellViewModelDelegate?
    var listImageLiked: [CollectorImage] = []
    enum Action {
        case isLike
        case reaction
    }

    // MARK: - Function

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

    func setupObserve() {
        do {
            let realm = try Realm()
            notificationToken = realm.objects(CollectorImage.self).observe({ (_) in
                self.delegate?.viewModel(self)
            })
        } catch {
            HUD.showError(withStatus: "Something was wrong")
        }
    }

    func isLike() -> Bool {
        guard let imageID = collectorImage?.imageID else { return false }
        do {
            let realm = try Realm()
            let image = realm.objects(CollectorImage.self).filter("imageID = '\(imageID)'")
            if image.count != 0 {
                return true
            } else {
                return false
            }
        } catch {
            HUD.showError(withStatus: "Something was wrong")
            return false
        }
    }

    func reaction() -> Bool {
        guard let imageID = collectorImage?.imageID else { return false }
        do {
            if !isLike() {
                let realm = try Realm()
                let image = CollectorImage()
                image.imageID = "\(collectorImage?.imageID ?? "")"
                image.imageUrl = "\(collectorImage?.imageUrl ?? "")"
                image.heigthImageForRealm = Double(collectorImage?.heigthImage ?? 0)
                image.widthImageForRealm = Double(collectorImage?.widthImage ?? 0)
                image.dateAppend = Date()
                image.albumID = "\(collectorImage?.albumID ?? "")"
                try realm.write {
                    realm.add(image)
                }
                return true
            } else {
                let realm = try Realm()
                let image = realm.objects(CollectorImage.self).filter("imageID = '\(imageID)'")
                try realm.write {
                    realm.delete(image)
                }
                return false
            }
        } catch {
            HUD.showError(withStatus: "Something was wrong")
            return false
        }
    }
}
