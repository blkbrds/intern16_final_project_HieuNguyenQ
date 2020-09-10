//
//  HomeViewController.swift
//  theCollectors
//
//  Created by hieungq on 7/27/20.
//  Copyright © 2020 hieungq. All rights reserved.
//

import UIKit
import Hero
import SDWebImage
import SwiftUtils

final class HomeViewController: BaseViewController {

    // MARK: - IBOutlet
    @IBOutlet private weak var homeCollectionView: UICollectionView!

    // MARK: - Properties
    let viewModel = HomeViewModel()
    let collectionViewLayout = CollectionViewLayout()
    let limit: Int = 20
    var currentPage: Int = 0
    var stopLoading = false

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupCollectionViewLayout()
        getDataForCollectionView(atPage: currentPage, withLimit: limit)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
        tabBarController?.changeTabBar(hidden: false)
    }

    // MARK: - Function
    override func setupNavigationBar() {
        navigationItem.title = "theCollectors"
    }

    private func setupCollectionView() {
        let homeCollectionViewCell = UINib(nibName: "HomeCollectionViewCell", bundle: .main)
        homeCollectionView.register(homeCollectionViewCell, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.backgroundColor = .clear
        homeCollectionView.hero.modifiers = [.cascade]
    }

    private func setupCollectionViewLayout() {
        homeCollectionView.collectionViewLayout = collectionViewLayout
        collectionViewLayout.delegate = self
    }

    func updateUI() {
        DispatchQueue.main.async {
            self.homeCollectionView.reloadData()
        }
    }

    private func getDataForCollectionView(atPage page: Int, withLimit perPage: Int) {
        HUD.show()
        HUD.setDefaultStyle(.dark)
        viewModel.getData(atPage: page, withLimit: perPage) { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success:
                this.currentPage += 1
                this.updateUI()
                HUD.dismiss()
            case .failure(let error):
                this.updateUI()
                HUD.dismiss()
                HUD.showError(withStatus: error.localizedDescription)
                HUD.setMinimumDismissTimeInterval(1)
                if error as NSObject == Api.Error.emptyData {
                    self?.stopLoading = true
                }
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
        cell.hero.isEnabled = true
        cell.hero.modifiers = [.fade, .scale(0.5)]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.collectorImages.count - 2 && !stopLoading {
            if let layout = self.homeCollectionView.collectionViewLayout as? CollectionViewLayout {
                layout.clearCache()
            }
            self.getDataForCollectionView(atPage: self.currentPage, withLimit: self.limit)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = homeCollectionView.cellForItem(at: indexPath)
        cell?.hero.id = "\(viewModel.collectorImages[indexPath.row].imageID)"
        let detailViewController = DetailViewController()
        detailViewController.viewModel = viewModel.getDetailViewModel(forIndexPath: indexPath)
        navigationController?.hero.isEnabled = true
        navigationController?.heroNavigationAnimationType = .none
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y == 0 {
            return
        } else if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            tabBarController?.changeTabBar(hidden: true)
        } else {
            tabBarController?.changeTabBar(hidden: false)
        }
    }
}

extension HomeViewController: CollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeOfImageAtIndexPath indexPath: IndexPath) -> CGSize {
        return viewModel.sizeOfImageAtIndexPath(atIndexPath: indexPath)
    }
}
