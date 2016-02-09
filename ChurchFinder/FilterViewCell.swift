//
//  FilterViewCell.swift
//  ChurchFinder
//
//  Created by Sarah Burgess on 2/8/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//

import UIKit

class FilterViewCell: UITableViewCell {

    @IBOutlet weak var filterCategoryLabel: UILabel!
    @IBOutlet weak var filterCategoryPicker: UIPickerView!
    var labelText: String!
    var pickerLabels = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func initialize(lT: String, pL: [String]){
        labelText = lT
        pickerLabels = pL
        filterCategoryLabel.text = labelText

    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
