//
//  CreateListVC.swift
//  ToDoList
//
//  Created by Kishore P on 25/02/22.
//

import UIKit

class CreateListVC: UIViewController {
    
    static func getVC() -> CreateListVC {
        guard let viewController = UIStoryboard(name: "CreateList", bundle: nil).instantiateViewController(withIdentifier: "CreateListVC") as? CreateListVC else {
            fatalError()
        }
        return viewController
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taskNameTitleLabel: UILabel!
    @IBOutlet weak var taskValueField: UITextField! {
        didSet {
            taskValueField.placeholder = TaskPlaceHolder
        }
    }
    @IBOutlet weak var tagTitleLabel: UILabel!
    @IBOutlet weak var tagValueField: UITextField! {
        didSet {
            tagValueField.placeholder = tagPlaceHolder
        }
    }
    @IBOutlet weak var priorityTitleLabel: UILabel!
    @IBOutlet weak var priorityValueSegment: UISegmentedControl!
    @IBOutlet weak var createButton: UIButton! {
        didSet {
            createButton.setTitle("Create", for: .normal)
            createButton.layer.cornerRadius = 6
        }
    }
    @IBOutlet weak var bottomView : UIView! {
        didSet {
            bottomView.layer.cornerRadius = 10
            bottomView.clipsToBounds = true
        }
    }
    @IBOutlet weak var topView : UIView!
    
    var viewModel : ToDoListVM!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        // Do any additional setup after loading the view.
    }
    
    @objc func closeAction(sender: UIView) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func initialSetUp() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        titleLabel.text = kCreateTitle
        taskNameTitleLabel.text = kTaskTitle
        tagTitleLabel.text = kTagTitle 
        priorityTitleLabel.text = kPriorityTitle
        tagValueField.setBoarder()
        taskValueField.setBoarder()
        setSegementValues()

        NotificationCenter.default.addObserver(self, selector: #selector(CreateListVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateListVC.keyboardWillHide), name: UIResponder.keyboardWillShowNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self,action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func setSegementValues() {
        priorityValueSegment.removeAllSegments()
        for index in 0..<viewModel.segmentArray.count {
            priorityValueSegment.insertSegment(withTitle: viewModel.segmentArray[index] , at: index, animated: true)
        }
        priorityValueSegment.selectedSegmentIndex = 0
    }
    
    @objc private func hideKeyboard() {
        self.view.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        self.view.frame.origin.y -= keyboardFrame.height
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        self.view.frame.origin.y += keyboardFrame.height
    }
    
    @IBAction func segmentSelectionChanged(_ sender: UISegmentedControl) {
        priorityValueSegment.selectedSegmentIndex = sender.selectedSegmentIndex
    }
    
    @IBAction func createButtonAction(_ sender: UIButton) {
        if tagValueField.text != "" && taskValueField.text != "" {
            let newList = ToDoList(title: taskValueField.text ?? "", author: "Kishore", tag: tagValueField.text ?? "", isCompleted: false, priority: viewModel.getPriorityValue(index: priorityValueSegment.selectedSegmentIndex), id: viewModel.createUniqueId())
            viewModel.setCreatedvalues(list: newList)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension CreateListVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
