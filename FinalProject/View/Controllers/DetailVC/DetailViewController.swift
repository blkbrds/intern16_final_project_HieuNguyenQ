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
    @IBOutlet private weak var detailCollectionView: UICollectionView!

    // MARK: - Properties
    var viewModel = DetailViewModel()
    var currentPage: Int = 0
    var collectionViewCellHeight: CGFloat = 0
    var collectionViewCellWidth: CGFloat = 0

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.changeTabBar(hidden: false)
    }

    // MARK: - Function
    override func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        tabBarController?.changeTabBar(hidden: false)
    }

    private func setupCollectionView() {
        collectionViewCellHeight = UIScreen.main.bounds.height - ((tabBarController?.tabBar.frame.height).unwrapped) - UIApplication.shared.statusBarFrame.height
        collectionViewCellWidth = UIScreen.main.bounds.width
        let nib = UINib(nibName: "DetailCollectionViewCell", bundle: Bundle.main)
        detailCollectionView.register(nib, forCellWithReuseIdentifier: "DetailCollectionViewCell")
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        getDataForCollectionView()
        detailCollectionView.layoutIfNeeded()
        guard let selectedIndex = viewModel.selectedIndex else { return }
        detailCollectionView.scrollToItem(at: selectedIndex, at: .left, animated: false)
    }

    private func updateUI() {
        DispatchQueue.main.async {
            self.detailCollectionView.reloadData()
        }
    }

    private func getDataForCollectionView() {
        if currentPage == 0 {
            currentPage += viewModel.collectorImages.count / 20
            updateUI()
        } else {
            viewModel.getData(page: currentPage, limit: 20) { [weak self] result in
                guard let this = self else { return }
                switch result {
                case .failure(let error):
                    HUD.showError(withStatus: error.localizedDescription)
                    HUD.setMaximumDismissTimeInterval(2)
                case .success:
                    this.currentPage += 1
                    this.updateUI()
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
        cell.hero.id = "\(viewModel.collectorImages[indexPath.row].imageID)"
        cell.hero.modifiers = [.fade, .scale(0.5)]
        cell.delegate = self
        cell.actionBlock = {
            self.navigationController?.popViewController(animated: true)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.collectorImages.count - 10 {
            getDataForCollectionView()
        }
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Config.inset
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionViewCellWidth, height: collectionViewCellHeight)
    }
}

extension DetailViewController: CollectionViewCellDelegate {
    func cell(_ cell: DetailCollectionViewCell, needPerformAction action: DetailCollectionViewCell.Action) {
        switch action {
        case .pushToDetail(let detailVC):
            navigationController?.hero.isEnabled = true
            navigationController?.heroNavigationAnimationType = .none
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension DetailViewController {
    struct Config {
        static let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
