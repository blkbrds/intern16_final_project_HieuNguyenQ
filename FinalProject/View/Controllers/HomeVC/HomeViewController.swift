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

final class HomeViewController: BaseViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var homeCollectionView: UICollectionView!

    // MARK: - Properties
    let viewModel = HomeViewModel()
    let collectionViewLayout = CollectionViewLayout()
    let limit: Int = 20
    var numberOfColumn: Int = 3
    var currentPage: Int = 0
    var imageButtonChange = #imageLiteral(resourceName: "twoColumn")
    var changeColumnButton = UIBarButtonItem()

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
        changeColumnButton = UIBarButtonItem(image: imageButtonChange, style: .plain, target: self, action: #selector(changeNumber))
        changeColumnButton.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        navigationItem.rightBarButtonItem = changeColumnButton
    }

    @objc func changeNumber() {
        if numberOfColumn == 3 {
            numberOfColumn = 2
            changeColumnButton.image = #imageLiteral(resourceName: "threeColumn")
        } else {
            numberOfColumn = 3
            changeColumnButton.image = #imageLiteral(resourceName: "twoColumn")
        }
        collectionViewLayout.numberOfColumn = numberOfColumn
        if let layout = self.homeCollectionView.collectionViewLayout as? CollectionViewLayout {
            layout.clearCache()
        }
        updateUI()
    }

    private func setupCollectionView() {
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        let homeCollectionViewCell = UINib(nibName: "HomeCollectionViewCell", bundle: .main)
        homeCollectionView.register(homeCollectionViewCell, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        homeCollectionView.backgroundColor = .clear
        homeCollectionView.hero.modifiers = [.cascade]
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
        cell.hero.id = "\(viewModel.collectorImages[indexPath.row].imageID)"
        cell.hero.modifiers = [.fade, .scale(0.5)]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if currentPage == 1 ? indexPath.row == viewModel.collectorImages.count - 2 : indexPath.row == viewModel.collectorImages.count - 10 {
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
        let collectorImage = viewModel.collectorImages[indexPath.row]
        return CGSize(width: collectorImage.widthImage, height: collectorImage.heigthImage)
    }
}
