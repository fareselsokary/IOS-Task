//
//  AppDelegate.swift
//  IOS Task
//
//  Created by fares on 03/12/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setRoot()
        return true
    }

    func setRoot() {
        let vc = UIStoryboard.Main.instantiateViewController(withIdentifier: "DocumentListViewController")
        window?.rootViewController = AppNavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
    }
}
