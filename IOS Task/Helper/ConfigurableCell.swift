//
//  ConfigurableCell.swift
//  IOS Task
//
//  Created by fares on 05/12/2021.
//

import Foundation

protocol ConfigurableCell { // Implemented in UIViewCell
    static var reuseIdentifier: String { get }
    associatedtype DataType
    func configure(data: DataType)
}
