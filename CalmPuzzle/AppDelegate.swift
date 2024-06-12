//
//  AppDelegate.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/16/24.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  let injectionContainer = AppContainer()
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
    let mainVC = injectionContainer.makeMainViewController()

    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    window?.rootViewController = mainVC

    return true
  }
}