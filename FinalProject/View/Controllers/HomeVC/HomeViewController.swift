//
//  HomeViewController.swift
//  theCollectors
//
//  Created by hieungq on 7/27/20.
//  Copyright © 2020 hieungq. All rights reserved.
//

import UIKit

final class HomeViewController: BaseViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var homeCollectionView: UICollectionView!

    // MARK: - Properties
    let viewModel = HomeViewModel()
    let limit: Int = 20
    var currentPage: Int = 0

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupCollectionViewLayout()
        getDataForCollectionView(atPage: currentPage, withLimit: limit)
    }

    // MARK: - Function
    override func setupTitle() {
        navigationItem.title = "theCollectors"
    }

    private func setupCollectionView() {
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        let homeCollectionViewCell = UINib(nibName: "HomeCollectionViewCell", bundle: .main)
        homeCollectionView.register(homeCollectionViewCell, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        homeCollectionView.backgroundColor = .clear
    }

    private func setupCollectionViewLayout() {
        let collectionViewLayout = CollectionViewLayout()
        homeCollectionView.collectionViewLayout = collectionViewLayout
        collectionViewLayout.numberOfColumn = 3
        collectionViewLayout.delegate = self
    }

    func updateUI() {
        DispatchQueue.main.async {
            self.homeCollectionView.reloadData()
        }
    }

    private func getDataForCollectionView(atPage page: Int, withLimit perPage: Int) {
        self.viewModel.getData(atPage: page, withLimit: perPage) { (result) in
            if result.error == nil {
                self.updateUI()
                self.currentPage += 1
            } else {
                print(result)
            }
        }
    }
}

    // MARK: - Extension

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.collectorImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        cell.viewModel = viewModel.cellForItem(atIndexPath: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.collectorImages.count - 10 {
            if let layout = homeCollectionView.collectionViewLayout as? CollectionViewLayout {
                layout.clearCache()
            }
            getDataForCollectionView(atPage: currentPage, withLimit: limit)
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y == 0 {
            return
        } else if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            changeTabBar(hidden: true)
        } else {
            changeTabBar(hidden: false)
        }
    }

    private func changeTabBar(hidden: Bool) {
        guard let tabBar = tabBarController?.tabBar else { return }
        if tabBar.isHidden == hidden { return }
        let frameY = hidden ? tabBar.frame.size.height + tabBar.frame.size.height : -tabBar.frame.size.height - tabBar.frame.size.height
        tabBar.isHidden = false

        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut, animations: {
            tabBar.frame = tabBar.frame.offsetBy(dx: 0, dy: frameY)
        }, completion: { _ in
            tabBar.isHidden = hidden
        })
    }
}

extension HomeViewController: CollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeOfImageAtIndexPath indexPath: IndexPath) -> CGSize {
        let collectorImage = viewModel.collectorImages[indexPath.row]
        return CGSize(width: collectorImage.widthImage, height: collectorImage.heigthImage)
    }
}
