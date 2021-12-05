//
//  String.swift
//  IOS Task
//
//  Created by fares on 05/12/2021.
//

import Foundation


extension String {
    var isBlank: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || self == ""
    }
}
