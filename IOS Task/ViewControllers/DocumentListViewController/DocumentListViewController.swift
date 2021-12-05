//
//  DocumentListViewController.swift
//  IOS Task
//
//  Created by fares on 03/12/2021.
//

import Combine
import UIKit

class DocumentListViewController: UIViewController {
    @IBOutlet weak var searchTypeLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    private let cellIdentifier = "Cell"
    private var documents = [Document]()
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: DocumentListViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    @IBAction func searchTypeButton(_ sender: Any) {
        showSearchTypeAlert()
    }
}

extension DocumentListViewController {
    private func setupUI() {
        navigationItem.title = "Open Library"
        searchTextField.delegate = self
        searchTextField.returnKeyType = .search
        setupTableView()
    }

    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
    }
}

extension DocumentListViewController {
    private func showSearchTypeAlert() {
        alertController(withTitle: "Search type",
                        message: nil,
                        alertStyle: .actionSheet,
                        withCancelButton: true,
                        cancelButtonTitle: "Cancel",
                        buttonsTitles: SearchType.allCases.map({ $0.name })) { [weak self] buttonIndex in
            self?.viewModel?.changeSearchType(SearchType(rawValue: buttonIndex) ?? .all)
        }
    }
}

extension DocumentListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if documents.isEmpty {
            tableView.setEmptyMessage("No results found")
        } else {
            tableView.restore()
        }
        return documents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        cell.selectionStyle = .none
        let data = documents[indexPath.row]
        cell.imageView?.image = UIImage(named: "bell-1")
        cell.textLabel?.text = data.title
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        cell.detailTextLabel?.text = data.authorName?.joined(separator: ", ") ?? data.authorName?.description
        cell.detailTextLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        cell.detailTextLabel?.textColor = .lightGray
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }
}

extension DocumentListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard.Main.instantiateViewController(withIdentifier: "DocumentDetailsViewController") as? DocumentDetailsViewController {
            vc.document = documents[indexPath.row]
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension DocumentListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return false }
        searchTextField.resignFirstResponder()
        viewModel?.getDocuments(with: text)
        return true
    }
}

extension DocumentListViewController: DocumentDetailsViewControllerDelegate {
    func didSelectTitle(_ title: String?) {
        guard let text = title, !text.isEmpty else { return }
        searchTextField.text = text
        viewModel?.changeSearchType(.title)
        viewModel?.getDocuments(with: text)
    }

    func didSelectAuthorName(_ name: String?) {
        guard let text = name, !text.isEmpty else { return }
        searchTextField.text = text
        viewModel?.changeSearchType(.author)
        viewModel?.getDocuments(with: text)
    }
}

extension DocumentListViewController {
    private func bindViewModel() {
        viewModel = DocumentListViewModel(apiService: DocumentListService())

        viewModel?.$searchType
            .receive(on: DispatchQueue.main)
            .sink { error in
                print(error)
            } receiveValue: { [weak self] type in
                self?.searchTypeLabel.text = type.name
            }.store(in: &cancellables)

        viewModel?.$documents
            .receive(on: DispatchQueue.main)
            .sink { error in
                print(error)
            } receiveValue: { [weak self] response in
                self?.documents = response
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
                guard let self = self, !error.isEmpty else { return }
                self.alertMessage(title: "", userMessage: error, complition: nil)
            }.store(in: &cancellables)
    }
}
