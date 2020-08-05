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
    let dummy: [UIImage] = [#imageLiteral(resourceName: "7"), #imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "4"), #imageLiteral(resourceName: "3"), #imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "5"), #imageLiteral(resourceName: "7"), #imageLiteral(resourceName: "7"), #imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "4"), #imageLiteral(resourceName: "3"), #imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "5"), #imageLiteral(resourceName: "7"), #imageLiteral(resourceName: "7"), #imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "4"), #imageLiteral(resourceName: "3"), #imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "5"), #imageLiteral(resourceName: "7"), #imageLiteral(resourceName: "7"), #imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "4"), #imageLiteral(resourceName: "3"), #imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "5"), #imageLiteral(resourceName: "7"), #imageLiteral(resourceName: "7"), #imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "4"), #imageLiteral(resourceName: "3"), #imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "5"), #imageLiteral(resourceName: "7")]
    let viewModel = HomeViewModel()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupCollectionViewLayout()
        getDataForCollectionView()
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
        homeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(homeCollectionView)
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
        let collectionViewLayout = CollectionViewLayout()
        homeCollectionView.collectionViewLayout = collectionViewLayout
        collectionViewLayout.delegate = self
    }

    private func getDataForCollectionView() {
        viewModel.getData()
    }
}

    // MARK: - Extension

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        cell.viewModel = viewModel.cellForItem(atIndexPath: indexPath)
        return cell
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
        return dummy[indexPath.row].size
    }
}
