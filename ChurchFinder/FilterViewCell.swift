/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Michael Curtis
Created: 24/02/16
*/

import UIKit
class FilterViewCell: UITableViewCell  {

    @IBOutlet weak var filterCategoryLabel: UILabel!
    @IBOutlet var view: UIView!
    
    var labelText: String!
    var cellName: String!
    var pickerLabels = [String]()
    
    @IBOutlet var selectedFilterLabel: UILabel!
    @IBOutlet var goButton: UIButton!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.view.bringSubviewToFront(view)
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
