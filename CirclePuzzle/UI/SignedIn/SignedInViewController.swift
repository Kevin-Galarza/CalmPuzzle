//
//  SignedInViewController.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/22/24.
//

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
    }
    
    private func constructHierarchy() {
        browseViewController.tabBarItem = UITabBarItem(title: "Browse", image: nil, tag: 0)
        dailyPuzzleViewController.tabBarItem = UITabBarItem(title: "Daily Puzzle", image: nil, tag: 1)
        shopViewController.tabBarItem = UITabBarItem(title: "Shop", image: nil, tag: 2)
        myPuzzlesViewController.tabBarItem = UITabBarItem(title: "My Puzzles", image: nil, tag: 3)

        self.viewControllers = [browseViewController, dailyPuzzleViewController, shopViewController, myPuzzlesViewController]
    }
}
