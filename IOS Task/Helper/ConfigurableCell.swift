//
//  ConfigurableCell.swift
//  IOS Task
//
//  Created by fares on 05/12/2021.
//

import Foundation

protocol ConfigurableCell { // Implemented in UIViewCell
    static var reuseIdentifier: String { get }
    static func getCellIdentifier() -> String
    associatedtype DataType
    func configure(data: DataType)
}

extension ConfigurableCell {
    static var reuseIdentifier: String { return String(describing: Self.self) }
    static func getCellIdentifier() -> String {
        return reuseIdentifier
    }
}

