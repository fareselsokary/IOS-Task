//
//  AppNavigationController.swift
//  IOS Task
//
//  Created by fares on 04/12/2021.
//

import UIKit

// MARK: - AppNavigationController

class AppNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                             NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        navigationBar.barStyle = .default
        navigationBar.backgroundColor = .white
        navigationBar.isTranslucent = false
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

