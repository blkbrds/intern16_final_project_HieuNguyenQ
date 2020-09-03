//
//  HomeViewController.swift
//  theCollectors
//
//  Created by hieungq on 7/27/20.
//  Copyright © 2020 hieungq. All rights reserved.
//

import UIKit
import SwiftUtils

final class HomeViewController: BaseViewController {

    // MARK: - IBOutlet
    @IBOutlet private weak var homeCollectionView: UICollectionView!

    // MARK: - Properties
    let viewModel = HomeViewModel()
    let collectionViewLayout = CollectionViewLayout()
    let limit: Int = 20
    var numberOfColumn: Int = 3
    var currentPage: Int = 0
    var imageButtonChange = #imageLiteral(resourceName: "threeColumn")
    var changeColumnButton = UIBarButtonItem()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupCollectionViewLayout()
        getDataForCollectionView(atPage: currentPage, withLimit: limit)
    }

    // MARK: - Function
    override func setupNavigationBar() {
        navigationItem.title = "theCollectors"
        changeColumnButton = UIBarButtonItem(image: imageButtonChange, style: .plain, target: self, action: #selector(changeNumber))
        changeColumnButton.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        navigationItem.rightBarButtonItem = changeColumnButton
    }

    @objc func changeNumber() {
        if numberOfColumn == 3 {
            numberOfColumn = 2
            changeColumnButton.image = #imageLiteral(resourceName: "twoColumn")
        } else {
            numberOfColumn = 3
            changeColumnButton.image = #imageLiteral(resourceName: "threeColumn")
        }
        collectionViewLayout.numberOfColumn = numberOfColumn
        if let layout = self.homeCollectionView.collectionViewLayout as? CollectionViewLayout {
            layout.clearCache()
        }
        updateUI()
    }

    private func setupCollectionView() {
        let homeCollectionViewCell = UINib(nibName: "HomeCollectionViewCell", bundle: .main)
        homeCollectionView.register(homeCollectionViewCell, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        let constrains = [
            homeCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant:
                     8),
            homeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            homeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            homeCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(constrains)
        homeCollectionView.backgroundColor = .clear
    }

    private func setupCollectionViewLayout() {
        homeCollectionView.collectionViewLayout = collectionViewLayout
        collectionViewLayout.numberOfColumn = numberOfColumn
        collectionViewLayout.delegate = self
    }

    func updateUI() {
        DispatchQueue.main.async {
            self.homeCollectionView.reloadData()
        }
    }

    private func getDataForCollectionView(atPage page: Int, withLimit perPage: Int) {
        HUD.show()
        viewModel.getData(atPage: page, withLimit: perPage) { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            switch result {
            case .success:
                this.currentPage += 1
                this.updateUI()
            case .failure(let error):
                this.alert(msg: error.localizedDescription, handler: nil)
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
            // reducing load continuously
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if let layout = self.homeCollectionView.collectionViewLayout as? CollectionViewLayout {
                    layout.clearCache()
                }
                self.getDataForCollectionView(atPage: self.currentPage, withLimit: self.limit)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(viewModel.collectorImages[indexPath.row].albumID)
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
        }, completion: { (_) in
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
