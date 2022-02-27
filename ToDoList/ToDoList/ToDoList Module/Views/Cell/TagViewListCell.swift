//
//  TagViewListCell.swift
//  ToDoList
//
//  Created by Kishore P on 25/02/22.
//

import UIKit

class TagViewListCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView! {
        didSet {
            cardView.addShadow()
        }
    }
    @IBOutlet weak var priorityColorView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(list: ToDoList, priorityColor: UIColor) {
        titleLabel.text = list.title
        priorityColorView.tintColor = priorityColor
    }

}
