//
//  DocumentDetailsViewController.swift
//  IOS Task
//
//  Created by fares on 05/12/2021.
//

import Combine
import UIKit

// MARK: - Document Details View Controller Delegate

protocol DocumentDetailsViewControllerDelegate: AnyObject {
    func didSelectTitle(_ title: String?)
    func didSelectAuthorName(_ name: String?)
}

class DocumentDetailsViewController: UIViewController {
    // MARK: - @IBOutlet

    @IBOutlet weak var tableView: UITableView!

    // MARK: - properties

    var document: Document?
    private var isbn = [ISBNDetails]()
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: DocumentDetailsViewModel?

    weak var delegate: DocumentDetailsViewControllerDelegate?

    // MARK: - view life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
}

// MARK: - setupUI

extension DocumentDetailsViewController {
    private func setupUI() {
        setupTableView()
    }

    private func setupTableView() {
        tableView.register(UINib(nibName: ISBNTableViewCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: ISBNTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: DocumentDescriptionTableViewCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: DocumentDescriptionTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension DocumentDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return document == nil ? 0 : 1
        case 1:
            return isbn.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: DocumentDescriptionTableViewCell.reuseIdentifier, for: indexPath) as? DocumentDescriptionTableViewCell,
               let document = document {
                cell.configure(data: document)
                // handel title selection action
                cell.didslectTitle = { [weak self] title in
                    self?.delegate?.didSelectTitle(title)
                    self?.navigationController?.popViewController(animated: true)
                }

                // handel authoer name selection actionß
                cell.didslectAuthor = { [weak self] authorName in
                    self?.delegate?.didSelectAuthorName(authorName)
                    self?.navigationController?.popViewController(animated: true)
                }
                return cell
            }
            return UITableViewCell()
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ISBNTableViewCell.reuseIdentifier, for: indexPath) as? ISBNTableViewCell {
                cell.configure(data: isbn[indexPath.row])
                // handel title selection action
                cell.didslectTitle = { [weak self] title in
                    self?.delegate?.didSelectTitle(title)
                    self?.navigationController?.popViewController(animated: true)
                }

                // handel authoer name selection actionß
                cell.didslectAuthor = { [weak self] authorName in
                    self?.delegate?.didSelectAuthorName(authorName)
                    self?.navigationController?.popViewController(animated: true)
                }
                return cell
            }
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - bindViewModel

extension DocumentDetailsViewController {
    private func bindViewModel() {
        viewModel = DocumentDetailsViewModel(apiService: DocumentDetailsService())
        if let isbn = document?.isbn {
            viewModel?.getISBN(isbn)
        }

        viewModel?.$isbn
            .receive(on: DispatchQueue.main)
            .sink { error in
                print(error)
            } receiveValue: { [weak self] response in
                self?.isbn = response
                self?.tableView.reloadData()
            }.store(in: &cancellables)

        viewModel?.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { error in
                print(error)
            } receiveValue: { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading {
                    self.showSpinner(onView: self.view)
                } else {
                    self.removeSpinner(fromView: self.view)
                }
            }.store(in: &cancellables)

        viewModel?.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { error in
                print(error)
            } receiveValue: { [weak self] error in
                guard let self = self, !error.isBlank else { return }
                self.alertMessage(title: "", userMessage: error, complition: nil)
            }.store(in: &cancellables)
    }
}
