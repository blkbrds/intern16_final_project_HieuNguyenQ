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
        homeNavigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "flame", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)), selectedImage: UIImage(systemName: "flame.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)))

        let cameraViewController = CameraViewController()
        let cameraNavigationController = BaseNavigationController(rootViewController: cameraViewController)
        cameraNavigationController.tabBarItem = UITabBarItem(title: "", image: nil, tag: 1)
        let favoriteViewController = FavouriteViewController()
        let favoriteNavigationController = BaseNavigationController(rootViewController: favoriteViewController)
        favoriteViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)), selectedImage: UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)))
        let viewControllers = [homeNavigationController, cameraNavigationController, favoriteNavigationController]
        self.viewControllers = viewControllers
        self.delegate = self

        tabBar.tintColor = #colorLiteral(red: 0.4125089049, green: 0.8123833537, blue: 0.9942517877, alpha: 1)
        tabBar.unselectedItemTintColor =  #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        tabBar.backgroundColor = #colorLiteral(red: 0.07139258832, green: 0.07140976936, blue: 0.07138884813, alpha: 1)
        tabBar.backgroundImage = UIImage()
        tabBar.layer.cornerRadius = 15

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

        tabBarItemCenter.isUserInteractionEnabled = true
        tabBarItemCenter.backgroundColor = #colorLiteral(red: 0.07139258832, green: 0.07140976936, blue: 0.07138884813, alpha: 1)
        tabBarItemCenter.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        tabBarItemCenter.layer.shadowColor = #colorLiteral(red: 0.6052098165, green: 0.6112019929, blue: 0.6112019929, alpha: 1)
        tabBarItemCenter.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        tabBarItemCenter.layer.shadowRadius = 5
        tabBarItemCenter.layer.shadowOpacity = 1
        tabBarItemCenter.layer.cornerRadius = tabBarItemCenterHeight / 2
        tabBarItemCenter.setImage(UIImage(systemName: "camera", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)), for: .normal)
        tabBarItemCenter.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        centerButton = tabBarItemCenter
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
