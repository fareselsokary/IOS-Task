//
//  DocumentListViewController.swift
//  IOS Task
//
//  Created by fares on 03/12/2021.
//

import Combine
import UIKit

class DocumentListViewController: UIViewController {
    // MARK: -

    @IBOutlet weak var searchTypeLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    // MARK: -

    private let cellIdentifier = "Cell"
    private var documents = [Document]()
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: DocumentListViewModel?

    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    // MARK: -

    @IBAction func searchTypeButton(_ sender: Any) {
        showSearchTypeAlert()
    }
}

// MARK: -

extension DocumentListViewController {
    private func setupUI() {
        navigationItem.title = "Open Library"
        searchTextField.delegate = self
        searchTextField.returnKeyType = .search
        setupTableView()
    }

    private func setupTableView() {
        tableView.register(DocumentTableViewCell.self, forCellReuseIdentifier: DocumentTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
    }
}

// MARK: - show Search Type Alert

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

// MARK: - UITableViewData Source

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
        if let cell = tableView.dequeueReusableCell(withIdentifier: DocumentTableViewCell.reuseIdentifier, for: indexPath) as? DocumentTableViewCell {
            cell.configure(data: documents[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UITableView Delegate

extension DocumentListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchTextField.resignFirstResponder()
        if let vc = UIStoryboard.Main.instantiateViewController(withIdentifier: "DocumentDetailsViewController") as? DocumentDetailsViewController {
            vc.document = documents[indexPath.row]
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= documents.count - 2 {
            viewModel?.getNextPage()
        }
    }
}

// MARK: - UITextField Delegate

extension DocumentListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isBlank else { return false }
        searchTextField.resignFirstResponder()
        viewModel?.search(by: text)
        return true
    }
}

// MARK: - Document Details View Controller Delegate

extension DocumentListViewController: DocumentDetailsViewControllerDelegate {
    func didSelectTitle(_ title: String?) {
        handelSearchBySelection(searchType: .title, keyWord: title)
    }

    func didSelectAuthorName(_ name: String?) {
        handelSearchBySelection(searchType: .author, keyWord: name)
    }

    private func handelSearchBySelection(searchType: SearchType, keyWord: String?) {
        searchTextField.resignFirstResponder()
        guard let text = keyWord, !text.isBlank else { return }
        searchTextField.text = text
        viewModel?.changeSearchType(searchType)
        viewModel?.search(by: text)
    }
}

// MARK: - bindViewModel

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
                guard let self = self, !error.isBlank else { return }
                self.alertMessage(title: "", userMessage: error, complition: nil)
            }.store(in: &cancellables)
    }
}
