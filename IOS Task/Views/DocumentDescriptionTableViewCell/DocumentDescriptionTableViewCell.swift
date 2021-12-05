//
//  DocumentDescriptionTableViewCell.swift
//  IOS Task
//
//  Created by fares on 05/12/2021.
//

import UIKit

class DocumentDescriptionTableViewCell: UITableViewCell {
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var documenttitle: UILabel!

    // MARK: -

    var didslectTitle: ((_ title: String?) -> Void)?
    var didslectAuthor: ((_ title: String?) -> Void)?
    private var document: Document!

    // MARK: -

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // add tap gesture to title Label
        let titleTap = UITapGestureRecognizer(target: self, action: #selector(titleLabletapped))
        documenttitle.isUserInteractionEnabled = true
        documenttitle.addGestureRecognizer(titleTap)

        // add tap gesture to auther label
        let authorTap = UITapGestureRecognizer(target: self, action: #selector(authorLabletapped))
        authorName.isUserInteractionEnabled = true
        authorName.addGestureRecognizer(authorTap)
    }

    // MARK: -

    @objc private func titleLabletapped() {
        didslectTitle?(document.title)
    }

    @objc private func authorLabletapped() {
        didslectAuthor?(document.authorName?.joined(separator: ", "))
    }
}

// MARK: -

extension DocumentDescriptionTableViewCell: ConfigurableCell {
    func configure(data: Document) {
        document = data
        documenttitle.text = data.title
        authorName.text = data.authorName?.joined(separator: ", ")
    }
}
