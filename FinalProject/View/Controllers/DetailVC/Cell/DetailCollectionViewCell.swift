//
//  DetailCollectionViewCell.swift
//  FinalProject
//
//  Created by hieungq on 8/11/20.
//  Copyright © 2020 Asiantech. All rights reserved.
//

import UIKit
import Hero
import Alamofire
import SDWebImage
import RealmSwift
import SwiftUtils

protocol CollectionViewCellDelegate: class {
    func cell(_ cell: DetailCollectionViewCell, needPerformAction action: DetailCollectionViewCell.Action)
}

final class DetailCollectionViewCell: UICollectionViewCell {

    // MARK: - Constriant
    @IBOutlet private weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageWidthConstraint: NSLayoutConstraint!

    // MARK: - IBOutlet
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var detailImageView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var similarCollectionView: UICollectionView!

    // MARK: - Properties
    var viewModel: DetailCellViewModel = DetailCellViewModel() {
        didSet {
            setupDetailImageView()
            setupCollectionView()
            getData()
        }
    }

    enum Action {
        case pushToDetail(detailVC: DetailViewController)
    }

    var actionBlock = { }
    weak var delegate: CollectionViewCellDelegate?

    // MARK: - Function
    private func setupDetailImageView() {
        detailImageView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).withAlphaComponent(0.5)
        detailImageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        if let imageHeight = viewModel.collectorImage?.heigthImage, let imageWidth = viewModel.collectorImage?.widthImage {
            if imageHeight * UIScreen.main.bounds.width / imageWidth <= frame.height {
                imageHeightConstraint.constant = imageHeight * UIScreen.main.bounds.width / imageWidth
            } else {
                imageHeightConstraint.constant = frame.height
                imageView.contentMode = .scaleAspectFit
                imageView.backgroundColor = .black
            }
            imageWidthConstraint.constant = UIScreen.main.bounds.width
        }

        if let imageUrl = viewModel.collectorImage?.imageUrl {
            let imageUrl = URL(string: imageUrl)
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imageView.sd_imageIndicator = SDWebImageProgressIndicator.`default`
            imageView.sd_setImage(with: imageUrl, placeholderImage: nil)
            imageView.sd_imageTransition = .fade
        }

        viewModel.delegate = self
        viewModel.setupObserve()

        if viewModel.isLike() {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }

    private func setupCollectionView() {
        similarCollectionView.delegate = self
        similarCollectionView.dataSource = self
        let nib = UINib(nibName: "SimilarCollectionViewCell", bundle: .main)
        similarCollectionView.register(nib, forCellWithReuseIdentifier: "SimilarCollectionViewCell")
        similarCollectionView.register(CollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")
        similarCollectionView.backgroundColor = .clear
        similarCollectionView.reloadData()
    }

    private func getData() {
        viewModel.getDataSimilar { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .failure(let error):
                HUD.showError(withStatus: error.localizedDescription)
                HUD.setMaximumDismissTimeInterval(2)
            case .success:
                this.updateUI()
            }
        }
    }

    private func updateUI() {
        similarCollectionView.reloadData()
    }

    @IBAction func likeButtonTouchUpInside(_ sender: Any) {
        if viewModel.reaction() {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }

    @IBAction private func backButtonTouchUpInside(_ sender: Any) {
        actionBlock()
    }

    @IBAction private func saveButtonTouchUpInside(_ sender: Any) {
        HUD.show(withStatus: "Saving picture ... ")
        guard let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            HUD.dismiss()
            HUD.setMinimumDismissTimeInterval(2)
            HUD.showError(withStatus: error.localizedDescription)
        } else {
            HUD.dismiss()
            HUD.setMinimumDismissTimeInterval(2)
            HUD.showSuccess(withStatus: "Save successfully")
        }
    }
}

// MARK: - Extension
extension DetailCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.collectorImageSimilars.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = similarCollectionView.dequeueReusableCell(withReuseIdentifier: "SimilarCollectionViewCell", for: indexPath) as? SimilarCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.viewModel = viewModel.cellForItemAt(indexPath: indexPath)
        cell.hero.isEnabled = true
        cell.hero.modifiers = [.fade, .scale(0.5)]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Config.sizeForItem
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Config.insets
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = similarCollectionView.cellForItem(at: indexPath)
        if let imageID = viewModel.collectorImage?.imageID {
            cell?.hero.id = imageID
        }
        let detailViewController = DetailViewController()
        detailViewController.viewModel = viewModel.getDetailViewModel(forIndexPath: indexPath)
        delegate?.cell(self, needPerformAction: .pushToDetail(detailVC: detailViewController))
    }
}

extension DetailCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = similarCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath)
            headerView.frame = CGRect(x: 0, y: 0, width: imageWidthConstraint.constant, height: imageHeightConstraint.constant + 76)
            headerView.addSubview(detailImageView)
            return headerView
        default:
            return UICollectionReusableView()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: imageWidthConstraint.constant, height: imageHeightConstraint.constant + 76)
    }
}

extension DetailCollectionViewCell: DetailCellViewModelDelegate {
    func viewModel(_ viewModel: DetailCellViewModel) {
        if viewModel.isLike() {
            self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
            self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}

extension DetailCollectionViewCell {
    struct Config {
        static let sizeForItem = CGSize(width: UIScreen.main.bounds.width / 2 - 16, height: 200)
        static let insets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}
