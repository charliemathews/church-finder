//
//  ChurchListCell.swift
//  ChurchFinder
//

import UIKit

class ChurchListCell: UITableViewCell {

    @IBOutlet var ChurchName : UILabel!
    @IBOutlet weak var ChurchImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
