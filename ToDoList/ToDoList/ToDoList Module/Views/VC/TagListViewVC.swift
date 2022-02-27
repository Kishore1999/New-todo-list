//
//  TagListViewVC.swift
//  ToDoList
//
//  Created by Kishore P on 25/02/22.
//

import UIKit

class TagListViewVC: UIViewController {

    @IBOutlet weak var tagListTableView: UITableView! {
        didSet {
            tagListTableView.register(UINib(nibName: "TagHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TagHeaderView")
        }
    }
    @IBOutlet var searchview: UISearchBar! {
        didSet {
            searchview.placeholder = KSearchPlaceHolder
        }
    }
    var viewModel : ToDoListVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }

    func initialSetUp() {
        navigationController?.navigationBar.topItem?.title = kTagTitle
        viewModel.setTagListDetails() { _ in
            DispatchQueue.main.async {
                self.tagListTableView.reloadData()
            }
        }
        viewModel.reloadTagTableView = { [weak self] in
            self?.tagListTableView.reloadData()
        }
        let tapGesture = UITapGestureRecognizer(target: self,action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
}

extension TagListViewVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.filteredTagList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredTagList[section].taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TagViewListCell", for: indexPath) as? TagViewListCell else {
            fatalError()
        }
        cell.configureCell(list: viewModel.filteredTagList[indexPath.section].taskList[indexPath.row], priorityColor: viewModel.getPriorityColor(priority: viewModel.filteredTagList[indexPath.section].taskList[indexPath.row].priority ?? Priority.low))
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TagHeaderView") as! TagHeaderView
        headerView.tagTitleLabel.text = viewModel.filteredTagList[section].tag
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
}

extension TagListViewVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.setTagListDetails() { _ in
                DispatchQueue.main.async {
                    self.tagListTableView.reloadData()
                }
            }
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.tagListFilterBySearch(searchText: searchBar.text ?? "") { _ in
            DispatchQueue.main.async {
                self.tagListTableView.reloadData()
            }
        }
        searchBar.resignFirstResponder()
    }
}
