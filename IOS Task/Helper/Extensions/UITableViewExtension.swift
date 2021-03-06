//
//  UITableViewExtension.swift
//  IOS Task
//
//  Created by fares on 04/12/2021.
//

import UIKit

extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .lightGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .boldSystemFont(ofSize: 15)
        messageLabel.sizeToFit()
        backgroundView = messageLabel
    }

    func restore() {
        backgroundView = nil
    }
}
