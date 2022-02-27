//
//  TagHeaderView.swift
//  ToDoList
//
//  Created by Kishore P on 26/02/22.
//

import UIKit

class TagHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var labelBackGroundView: UIView! {
        didSet {
            labelBackGroundView.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var tagTitleLabel: UILabel! {
        didSet {
            tagTitleLabel.layer.cornerRadius = 5
        }
    }

}
