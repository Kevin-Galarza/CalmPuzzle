//
//  SignedInViewController.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/22/24.
//

import UIKit

import UIKit

class SignedInViewController: NiblessTabBarController {

    let browseViewController: BrowseViewController
    let dailyPuzzleViewController: DailyPuzzleViewController
    let shopViewController: ShopViewController
    let myPuzzlesViewController: MyPuzzlesViewController
    
    init(browseViewController: BrowseViewController,
         dailyPuzzleViewController: DailyPuzzleViewController,
         shopViewController: ShopViewController,
         myPuzzlesViewController: MyPuzzlesViewController) {
        self.browseViewController = browseViewController
        self.dailyPuzzleViewController = dailyPuzzleViewController
        self.shopViewController = shopViewController
        self.myPuzzlesViewController = myPuzzlesViewController
        super.init()
        constructHierarchy()
        applyStyle()
    }
    
    private func constructHierarchy() {
        browseViewController.tabBarItem = UITabBarItem(title: "Browse", image: UIImage(named: "browse_tab_normal"), tag: 0)
        dailyPuzzleViewController.tabBarItem = UITabBarItem(title: "Daily Puzzle", image: UIImage(named: "daily_puzzle_tab_normal"), tag: 1)
//        shopViewController.tabBarItem = UITabBarItem(title: "Shop", image: UIImage(named: "shop_tab_normal"), tag: 2)
        myPuzzlesViewController.tabBarItem = UITabBarItem(title: "My Puzzles", image: UIImage(named: "my_puzzles_tab_normal"), tag: 3)

        self.viewControllers = [browseViewController, dailyPuzzleViewController, myPuzzlesViewController]
    }

    private func applyStyle() {
        // Set blur effect
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.tabBar.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tabBar.insertSubview(blurEffectView, at: 0)
        self.tabBar.isTranslucent = true
        self.tabBar.tintColor = Color.primaryPurple

        // Set text color and icons
        let normalAttributes = [NSAttributedString.Key.foregroundColor: Color.textBlack]
        let selectedAttributes = [NSAttributedString.Key.foregroundColor: Color.primaryPurple]

        UITabBarItem.appearance().setTitleTextAttributes(normalAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, for: .selected)

        // Set selected images for tab items if necessary
        browseViewController.tabBarItem.selectedImage = UIImage(named: "browse_tab_selected")
        dailyPuzzleViewController.tabBarItem.selectedImage = UIImage(named: "daily_puzzle_tab_selected")
//        shopViewController.tabBarItem.selectedImage = UIImage(named: "shop_tab_selected")
        myPuzzlesViewController.tabBarItem.selectedImage = UIImage(named: "my_puzzles_tab_selected")
    }
}

