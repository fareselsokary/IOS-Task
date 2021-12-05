//
//  DocumentTableViewCell.swift
//  IOS Task
//
//  Created by fares on 05/12/2021.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {
    // MARK: -

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        selectionStyle = .none
        textLabel?.numberOfLines = 0
        textLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        detailTextLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        detailTextLabel?.textColor = .lightGray
        detailTextLabel?.numberOfLines = 0
    }
}

extension DocumentTableViewCell: ConfigurableCell {
    static var reuseIdentifier: String {
        return "DocumentTableViewCell"
    }

    func configure(data: Document) {
        textLabel?.text = data.title
        detailTextLabel?.text = data.authorName?.joined(separator: ", ")
    }
}
