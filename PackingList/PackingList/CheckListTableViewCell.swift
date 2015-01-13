//
//  CheckListTableViewCell.swift
//  PackingList
//
//  Created by Ye, Weiran on 1/12/15.
//  Copyright (c) 2015 Ye, Weiran. All rights reserved.
//

import UIKit

class CheckListTableViewCell: UITableViewCell {

    var deleteButton = UIButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()

        deleteButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        deleteButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        contentView.addSubview(deleteButton)
        
        // view dictionary (for one row)
        let viewDict = ["deleteButton":deleteButton, "textLabel":self.textLabel]
        
        // position
        let cell_c_h = NSLayoutConstraint.constraintsWithVisualFormat("[deleteButton]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewDict)
        let cell_c_v = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[deleteButton]-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewDict)
        contentView.addConstraints(cell_c_h)
        contentView.addConstraints(cell_c_v)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
