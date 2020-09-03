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
    var currentPage: Int = 0
    var collectionViewCellHeight: CGFloat = 0
    var collectionViewCellWidth: CGFloat = 0

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
        collectionViewCellHeight = UIScreen.main.bounds.height - (tabBarController?.tabBar.frame.height ?? 0) - UIApplication.shared.statusBarFrame.height
        collectionViewCellWidth = UIScreen.main.bounds.width
        let nib = UINib(nibName: "DetailCollectionViewCell", bundle: Bundle.main)
        detailCollectionView.register(nib, forCellWithReuseIdentifier: "DetailCollectionViewCell")
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        detailCollectionView.layoutIfNeeded()
        guard let selectedIndex = viewModel.selectedIndex else { return }
        detailCollectionView.scrollToItem(at: selectedIndex, at: .centeredHorizontally, animated: false)
        getDataForCollectionView()
    }

    private func updateUI() {
        DispatchQueue.main.async {
            self.detailCollectionView.reloadData()
        }
    }

    private func getDataForCollectionView() {
        if currentPage == 0 {
            currentPage += viewModel.collectorImages.count / 20
            self.updateUI()
            // chưa hiểu
        } else {
            viewModel.getData(page: currentPage, limit: 20) { (result) in
                if result.error == nil {
                    self.updateUI()
                    self.currentPage += 1
                } else {
                    print(result)
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
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionViewCellWidth, height: collectionViewCellHeight)
    }
}

extension DetailViewController: CollectionViewCellDelegate {
    func pushToDetail(_ detailViewController: DetailViewController) {
        navigationController?.hero.isEnabled = true
        navigationController?.heroNavigationAnimationType = .none
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    func showAleart(_ alertError: Error?) {
        if let error = alertError {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Save successfully", message: "This image is saved successfully", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
            present(ac, animated: true)
        }
    }
}
