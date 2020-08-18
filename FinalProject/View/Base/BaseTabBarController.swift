//
//  BaseTabBarController.swift
//  theCollectors
//
//  Created by hieungq on 7/30/20.
//  Copyright © 2020 hieungq. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    // MARK: - Properties
    let tabBarItemCenter = UIButton()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    // MARK: - Function
    private func setupTabBar() {
        let homeViewController = HomeViewController()
        let homeNavigationController = BaseNavigationController(rootViewController: homeViewController)
        if #available(iOS 13.0, *) {
            homeNavigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "flame"), tag: 0)
        } else {
            // Fallback on earlier versions
        }

        let categoryViewController = CategoryViewController()
        let categoryNavigationController = BaseNavigationController(rootViewController: categoryViewController)
        categoryNavigationController.tabBarItem = UITabBarItem(title: "", image: nil, tag: 1)
        let favoriteViewController = FavoriteViewController()
        let favoriteNavigationController = BaseNavigationController(rootViewController: favoriteViewController)
        if #available(iOS 13.0, *) {
            favoriteNavigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "heart"), tag: 2)
        } else {
            // Fallback on earlier versions
        }

        let viewControllers = [homeNavigationController, categoryNavigationController, favoriteNavigationController]
        self.viewControllers = viewControllers
        self.delegate = self

        tabBar.tintColor = #colorLiteral(red: 0.4125089049, green: 0.8123833537, blue: 0.9942517877, alpha: 1)
        tabBar.unselectedItemTintColor =  #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        tabBar.backgroundColor = #colorLiteral(red: 0.1577239037, green: 0.1681370437, blue: 0.1926085055, alpha: 1)
        tabBar.backgroundImage = UIImage()
        tabBar.layer.cornerRadius = 15
        tabBar.alpha = 0.95

        tabBar.layer.shadowColor = #colorLiteral(red: 0.6052098165, green: 0.6112019929, blue: 0.6112019929, alpha: 1)
        tabBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        tabBar.layer.shadowRadius = 5
        tabBar.layer.shadowOpacity = 1
        setupMiddleButton()
    }

    private func setupMiddleButton() {
        let tabBarItemCenterHeight = tabBar.frame.size.height * 150 / 100
        let tabBarItemCenterWidth = tabBarItemCenterHeight
        let tabBarItemCenterFrameY = (-tabBarItemCenterHeight) / 2
        let tabBarItemCenterFrameX = view.bounds.width / 2 - tabBarItemCenterWidth / 2
        tabBarItemCenter.frame.origin = CGPoint(x: tabBarItemCenterFrameX, y: tabBarItemCenterFrameY)
        tabBarItemCenter.frame.size = CGSize(width: tabBarItemCenterWidth, height: tabBarItemCenterHeight)

        tabBarItemCenter.backgroundColor = #colorLiteral(red: 0.1577239037, green: 0.1681370437, blue: 0.1926085055, alpha: 1)
        tabBarItemCenter.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        tabBarItemCenter.layer.shadowColor = #colorLiteral(red: 0.6052098165, green: 0.6112019929, blue: 0.6112019929, alpha: 1)
        tabBarItemCenter.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        tabBarItemCenter.layer.shadowRadius = 5
        tabBarItemCenter.layer.shadowOpacity = 1
        tabBarItemCenter.layer.cornerRadius = tabBarItemCenterHeight / 2
        if #available(iOS 13.0, *) {
            tabBarItemCenter.setImage(UIImage(systemName: "square.on.square"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        tabBarItemCenter.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        tabBar.addSubview(tabBarItemCenter)
    }

    @objc private func menuButtonAction(sender: UIButton) {
        sender.tintColor = #colorLiteral(red: 0.4125089049, green: 0.8123833537, blue: 0.9942517877, alpha: 1)
        selectedIndex = 1
    }
}

extension BaseTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex != 1 {
            tabBarItemCenter.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
}
