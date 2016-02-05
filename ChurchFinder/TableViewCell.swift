//
//  TableViewCell.swift
//  ChurchFinder
//
//  Created by Michael Curtis on 2/2/16.
//  Copyright (c) 2016 Michael Curtis. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
