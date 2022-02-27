//
//  ToDoMainVC.swift
//  ToDoList
//
//  Created by Kishore P on 25/02/22.
//

import UIKit

class ToDoMainVC: UIViewController {

    @IBOutlet weak var mainListTableView: UITableView!
    @IBOutlet var searchview: UISearchBar! {
        didSet {
            searchview.placeholder = KSearchPlaceHolder
        }
    }
    var viewModel : ToDoListVM!
    var didTapOnTagButton : (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    func initialSetUp() {
        navigationController?.navigationBar.topItem?.title = kToDoTitle
        viewModel.setTodoListDetails() { _ in
            DispatchQueue.main.async {
                self.mainListTableView.reloadData()
            }
        }
        viewModel.reloadMainTableView = { [weak self] in
            self?.mainListTableView.reloadData()
        }
        let tapGesture = UITapGestureRecognizer(target: self,action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func presentTagListVC() {
        didTapOnTagButton?()
    }

}

extension ToDoMainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.toDoListDetail.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainToDoListCell", for: indexPath) as? MainToDoListCell else {
            fatalError()
        }
        cell.configureCell(list: viewModel.toDoListDetail[indexPath.row], priorityColor: viewModel.getPriorityColor(priority: viewModel.toDoListDetail[indexPath.row].priority ?? .low))
        cell.didTapOnButton = { [weak self] in
            self?.viewModel.changeCompletedValue(index: indexPath.row)
            self?.mainListTableView.reloadData()
        }
        cell.didTapOnTagButton = { [weak self] in
            self?.presentTagListVC()
        }
        if viewModel.toDoListDetail.count - 1 == indexPath.row && viewModel.toDoListDetail.count > 15 {
            viewModel.incrementPageCount()
            viewModel.setTodoListDetails() { _ in
                DispatchQueue.main.async {
                    self.mainListTableView.reloadData()
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
}

extension ToDoMainVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.toDoListDetail.removeAll()
            viewModel.pageCount = 0
            viewModel.setTodoListDetails() { _ in
                DispatchQueue.main.async {
                    self.mainListTableView.reloadData()
                }
            }
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.toDoListFilterBySearch(searchText: searchBar.text ?? "") { _ in
            DispatchQueue.main.async {
                self.mainListTableView.reloadData()
            }
        }
        searchBar.resignFirstResponder()
    }
}

extension ToDoMainVC: UITextFieldDelegate {
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        self.view.endEditing(true)
    }
}
