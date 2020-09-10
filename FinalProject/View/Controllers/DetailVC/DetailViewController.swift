//
//  DetailViewController.swift
//  FinalProject
//
//  Created by hieungq on 8/10/20.
//  Copyright © 2020 Asiantech. All rights reserved.
//

import UIKit
import Hero
import RealmSwift
import SwiftUtils

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
        let statusBarHeight = (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height).unwrapped
        collectionViewCellHeight = UIScreen.main.bounds.height - ((tabBarController?.tabBar.frame.height).unwrapped) - statusBarHeight
        collectionViewCellWidth = UIScreen.main.bounds.width
        let nib = UINib(nibName: "DetailCollectionViewCell", bundle: Bundle.main)
        detailCollectionView.register(nib, forCellWithReuseIdentifier: "DetailCollectionViewCell")
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        getDataForCollectionView()
    }

    private func updateUI() {
        UIView.animate(withDuration: 0, animations: {
            self.detailCollectionView.reloadData()
            self.detailCollectionView.layoutIfNeeded()
        }, completion: { [weak self] _ in
            guard let this = self else { return }
            guard let selectedIndexPath = this.viewModel.selectedIndexPath else { return }
            this.detailCollectionView.scrollToItem(at: selectedIndexPath, at: .left, animated: false)
        })
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

    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
        DispatchQueue.main.async { [weak self] in
            guard let this = self else { return }
            cell.hero.isEnabled = true
            if indexPath == this.viewModel.selectedIndexPath {
                cell.hero.id = "\(this.viewModel.collectorImages[indexPath.row].imageID)"
            }
            cell.hero.modifiers = [.fade, .scale(0.5)]
            cell.delegate = this
        }
        detailCollectionView.layoutIfNeeded()
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
