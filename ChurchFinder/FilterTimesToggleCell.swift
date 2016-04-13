/*
 Copyright 2016 Serious Llama and Grove City College. All rights reserved.
 
 Author: Charlie Mathews
 Created: 4/13/16
 */

import UIKit

class FilterTimesToggleCell: UITableViewCell {
    
    @IBOutlet weak var toggle: UISwitch!
    @IBAction func toggleFlip(sender: AnyObject) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
