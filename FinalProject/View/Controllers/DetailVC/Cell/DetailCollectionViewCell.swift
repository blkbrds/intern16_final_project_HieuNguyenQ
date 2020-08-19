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

protocol CollectionViewCellDelegate: class {
    func showAleart(_ alertError: Error?)
}

class DetailCollectionViewCell: UICollectionViewCell {

    // MARK: - Constriant
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!

    // MARK: - IBOutlet
    @IBOutlet weak var detailImageView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var similarCollectionView: UICollectionView!

    // MARK: - Properties
    var viewModel: DetailCellViewModel = DetailCellViewModel() {
        didSet {
            setupDetailImageView()
            setupCollectionView()
            //setupCollectionViewLayout()
            getData()
        }
    }
    var actionBlock = { }
    weak var delegate: CollectionViewCellDelegate?
    let collectionViewLayout = CollectionViewLayout()

    // MARK: - Function
    private func setupDetailImageView() {
        detailImageView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).withAlphaComponent(0.5)
        detailImageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        if let imageHeight = viewModel.collectorImage?.heigthImage, let imageWidth = viewModel.collectorImage?.widthImage {
            imageHeightConstraint.constant = imageHeight * UIScreen.main.bounds.width / imageWidth
            imageWidthConstraint.constant = UIScreen.main.bounds.width
        }
        if viewModel.collectorImage?.image != nil {
            imageView.image = viewModel.collectorImage?.image
        } else {
            if let imageUrl = viewModel.collectorImage?.imageUrl {
              Alamofire.request(imageUrl).responseData { (response) in
                    if let data = response.result.value {
                        self.viewModel.collectorImage?.image = UIImage(data: data)
                        self.imageView.image = UIImage(data: data)
                    } else {
                        self.viewModel.collectorImage?.image = nil
                    }
                }
            }
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
        viewModel.getDataSimilar { (result) in
            if result.error == nil {
                self.updateUI()
            } else {
                print(result)
            }
        }
    }

    private func updateUI() {
        DispatchQueue.main.async {
            self.similarCollectionView.reloadData()
        }
    }

    private func setupCollectionViewLayout() {
        similarCollectionView.collectionViewLayout = collectionViewLayout
        collectionViewLayout.numberOfColumn = 2
        collectionViewLayout.delegate = self
    }

    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        actionBlock()
    }

    @IBAction func likeButtonTouchUpInside(_ sender: Any) {

    }

    @IBAction func saveButtonTouchUpInside(_ sender: Any) {
        guard let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        delegate?.showAleart(error)
    }
}

    // MARK: - Extension
extension DetailCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.collectorImageSimilars.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = similarCollectionView.dequeueReusableCell(withReuseIdentifier: "SimilarCollectionViewCell", for: indexPath) as? SimilarCollectionViewCell else { return UICollectionViewCell() }
        cell.viewModel = viewModel.cellForItemAt(indexPath: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 414 / 2 - 16, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
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

extension DetailCollectionViewCell: CollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeOfImageAtIndexPath indexPath: IndexPath) -> CGSize {
        let collectorImage = viewModel.collectorImageSimilars[indexPath.row]
        return CGSize(width: collectorImage.widthImage, height: collectorImage.heigthImage)
    }
}
