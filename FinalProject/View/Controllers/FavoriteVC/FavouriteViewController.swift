//
//  FavoriteViewController.swift
//  theCollectors
//
//  Created by hieungq on 7/27/20.
//  Copyright © 2020 hieungq. All rights reserved.
//

import UIKit

final class FavouriteViewController: BaseViewController {

    // MARK: - IBOutlet
    @IBOutlet private weak var favouriteCollectionView: UICollectionView!

    // MARK: - Properties
    let viewModel = FavouriteViewModel()
    let collectionViewLayout = CollectionViewLayout()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupCollectionViewLayout()
        getDataForCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
        tabBarController?.changeTabBar(hidden: false)
    }

    // MARK: - Function
    override func setupNavigationBar() {
        navigationItem.title = "Favorite"
    }

    private func setupCollectionView() {
        viewModel.delegate = self
        viewModel.setupObserve()
        favouriteCollectionView.delegate = self
        favouriteCollectionView.dataSource = self
        let favouriteCollectionViewCell = UINib(nibName: "FavouriteCollectionViewCell", bundle: .main)
        favouriteCollectionView.register(favouriteCollectionViewCell, forCellWithReuseIdentifier: "FavouriteCollectionViewCell")
        favouriteCollectionView.backgroundColor = .clear
        favouriteCollectionView.hero.modifiers = [.cascade]
    }

    private func setupCollectionViewLayout() {
        favouriteCollectionView.collectionViewLayout = collectionViewLayout
        collectionViewLayout.delegate = self
    }

    func updateUI() {
        if let layout = self.favouriteCollectionView.collectionViewLayout as? CollectionViewLayout {
            layout.clearCache()
        }
        DispatchQueue.main.async {
            self.favouriteCollectionView.reloadData()
        }
    }

    private func getDataForCollectionView() {
        self.viewModel.getData() { (result) in
            if result.error == nil {
                self.updateUI()
            } else {
                print(result)
            }
        }
    }
}

    // MARK: - Extension
extension FavouriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.collectorImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteCollectionViewCell", for: indexPath) as? FavouriteCollectionViewCell else { return UICollectionViewCell() }
        cell.viewModel = viewModel.cellForItem(atIndexPath: indexPath)
        cell.hero.id = "\(viewModel.collectorImages[indexPath.row].imageID)"
        print(viewModel.collectorImages[indexPath.row].imageID)
        cell.hero.modifiers = [.fade, .scale(0.5)]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.viewModel = viewModel.getDetailViewModel(forIndexPath: indexPath)
        navigationController?.hero.isEnabled = true
        navigationController?.heroNavigationAnimationType = .none
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension FavouriteViewController: CollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeOfImageAtIndexPath indexPath: IndexPath) -> CGSize {
        let collectorImage = viewModel.collectorImages[indexPath.row]
        return CGSize(width: collectorImage.widthImage, height: collectorImage.heigthImage)
    }
}

extension FavouriteViewController: FavouriteViewModelDelegate {
    func viewModel(_ viewModel: FavouriteViewModel) {
        getDataForCollectionView()
    }
}
