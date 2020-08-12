//
//  DetailViewController.swift
//  FinalProject
//
//  Created by hieungq on 8/10/20.
//  Copyright © 2020 Asiantech. All rights reserved.
//

import UIKit
import Hero

final class DetailViewController: BaseViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var detailCollectionView: UICollectionView!

    // MARK: - Properties
    var viewModel = DetailViewModel()
    var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    // MARK: - Function
    override func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        tabBarController?.changeTabBar(hidden: false)
    }

    private func setupCollectionView() {
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        let nib = UINib(nibName: "DetailCollectionViewCell", bundle: Bundle.main)
        detailCollectionView.register(nib, forCellWithReuseIdentifier: "DetailCollectionViewCell")
        // force load cells before scrolling to the index
        detailCollectionView.layoutIfNeeded()
        detailCollectionView.scrollToItem(at: selectedIndex, at: .centeredHorizontally, animated: false)
        viewModel.getData(selectedIndex: selectedIndex.row, limit: 20) { (result) in
            if result.error != nil {
                DispatchQueue.main.async {
                    self.detailCollectionView.reloadData()
                }
            }
        }
    }
}

    // MARK: - Extension
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.collectorImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = detailCollectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as? DetailCollectionViewCell else { return UICollectionViewCell() }
        cell.viewModel = viewModel.cellForItemAt(indexPath: indexPath)
        cell.hero.id = "\(indexPath.row)"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: detailCollectionView.frame.width, height: detailCollectionView.frame.height - (tabBarController?.tabBar.frame.height ?? 0) - UIApplication.shared.statusBarFrame.height)
    }
}
