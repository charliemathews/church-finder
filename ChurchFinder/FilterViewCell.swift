/*
 Copyright 2016 Serious Llama and Grove City College. All rights reserved.
 
 Author: Charlie Mathews
 Created: 4/10/16
 */


import UIKit
class FilterViewCell: UITableViewCell  {

    @IBOutlet weak var filter_name: UILabel!
    @IBOutlet weak var filter_value: UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
