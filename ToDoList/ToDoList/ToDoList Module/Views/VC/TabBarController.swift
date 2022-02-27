//
//  ViewController.swift
//  ToDoList
//
//  Created by Kishore P on 25/02/22.
//

import UIKit

class TabBarController: UITabBarController {
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    let viewModel = ToDoListVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    // Initial setup for tab bar controller
    func initialSetUp() {
        viewControllers = [
            createNavController(for: mainToDoVC(), title: kToDoTitle, image: UIImage(systemName: "text.badge.checkmark") ?? UIImage(), selectedImage: UIImage(), tag: 0),
            createNavController(for: tagListVC(), title: kTagTitle, image: UIImage(systemName: "tag") ?? UIImage(), selectedImage: UIImage(), tag: 1)
        ]
    }
    
    // creating navigation controller
    func createNavController(for rootViewController: UIViewController, title: String, image: UIImage, selectedImage: UIImage, tag: Int) -> UIViewController {
        rootViewController.tabBarItem.title         = title
        rootViewController.tabBarItem.image         = image
        rootViewController.tabBarItem.tag           = tag
        rootViewController.navigationItem.title     = title
        rootViewController.tabBarItem.selectedImage = image
        return rootViewController
    }
    
    // redirect to main vc
    func mainToDoVC() -> ToDoMainVC {
        guard let viewController = UIStoryboard(name: "ToDoMain", bundle: nil).instantiateViewController(withIdentifier: "ToDoMainVC") as? ToDoMainVC else {
            fatalError()
        }
        viewController.viewModel = viewModel
        viewController.didTapOnTagButton = { [weak self] in
            self?.selectedIndex = 1
        }
        return viewController
    }
    
    // redirect to tag vc
    func tagListVC() -> TagListViewVC {
        guard let viewController = UIStoryboard(name: "TagListView", bundle: nil).instantiateViewController(withIdentifier: "TagListViewVC") as? TagListViewVC else {
            fatalError()
        }
        viewController.viewModel = viewModel
        return viewController
    }
    
    // add button action
    @IBAction func addBarButtonAction(_ sender: UIBarButtonItem) {
        let viewController = CreateListVC.getVC()
        viewModel.selectedTabBar = selectedIndex
        viewController.viewModel = viewModel
        viewController.modalPresentationStyle = .pageSheet
        self.present(viewController, animated: true, completion: nil)
    }
}

