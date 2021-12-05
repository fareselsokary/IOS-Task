//
//  ISBNTableViewCell.swift
//  IOS Task
//
//  Created by fares on 05/12/2021.
//

import UIKit

class ISBNTableViewCell: UITableViewCell {
    // MARK: -

    @IBOutlet weak var isbnTitle: UILabel!
    @IBOutlet weak var isbnImage: UIImageView!
    @IBOutlet weak var isbnAuthor: UILabel!

    // MARK: -

    var didslectTitle: ((_ title: String?) -> Void)?
    var didslectAuthor: ((_ title: String?) -> Void)?
    private var isbnDetails: ISBNDetails!

    // MARK: -

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // add tap gesture to title Label
        let titleTap = UITapGestureRecognizer(target: self, action: #selector(titleLabletapped))
        isbnTitle.isUserInteractionEnabled = true
        isbnTitle.addGestureRecognizer(titleTap)

        // add tap gesture to auther label
        let authorTap = UITapGestureRecognizer(target: self, action: #selector(authorLabletapped))
        isbnAuthor.isUserInteractionEnabled = true
        isbnAuthor.addGestureRecognizer(authorTap)
    }

    // MARK: -

    @objc private func titleLabletapped() {
        didslectTitle?(isbnDetails.details?.title)
    }

    @objc private func authorLabletapped() {
        didslectAuthor?(isbnDetails.details?.authors?.compactMap({ $0.name }).joined(separator: ", "))
    }
}

// MARK: -

extension ISBNTableViewCell: ConfigurableCell {
    func configure(data: ISBNDetails) {
        isbnDetails = data
        isbnTitle.text = data.details?.title
        isbnAuthor.text = data.details?.authors?.compactMap({ $0.name }).joined(separator: ", ")
        if let cover = data.thumbnailURL {
            isbnImage.downloaded(from: cover)
        }
    }
}
