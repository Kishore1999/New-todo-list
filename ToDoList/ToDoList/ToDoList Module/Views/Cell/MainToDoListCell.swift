//
//  MainToDoListCell.swift
//  ToDoList
//
//  Created by Kishore P on 25/02/22.
//

import UIKit

class MainToDoListCell: UITableViewCell {
    
    
    @IBOutlet weak var circleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagTitleLabel: UILabel!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var tagBackgroundView: UIView! {
        didSet {
            tagBackgroundView.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var cardView: UIView! {
        didSet {
            cardView.addShadow()
        }
    }
    @IBOutlet weak var tagTitleButton: UIButton!
    
    var didTapOnButton : (() -> Void)?
    var didTapOnTagButton : (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(list: ToDoList, priorityColor: UIColor) {
        titleLabel.text = list.title
//        tagTitleLabel.text = list.tag
        tagTitleButton.setTitle(list.tag, for: .normal)
        completedButton.setImage(list.isCompleted ? UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.blue) :UIImage(systemName: "circle") , for: .normal)
        circleImageView.tintColor = priorityColor
    }
    
    @IBAction func completedButtonAction(_ sender: UIButton) {
        didTapOnButton?()
    }
    
    @IBAction func tagButtonAction(_ sender: UIButton) {
        didTapOnTagButton?()
    }
}
