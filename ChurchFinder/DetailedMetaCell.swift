/*
 Copyright 2016 Serious Llama and Grove City College. All rights reserved.
 
 Author: Charlie Mathews
 */

import UIKit

class DetailedMetaCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
