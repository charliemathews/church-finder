/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Dan Mitchell
Created:
Modified: 24/02/16

Changelog
...

Sources
...
*/

import UIKit
import MapKit
import ParseUI

class ChurchListCell: UITableViewCell {

    @IBOutlet weak var churchImage: PFImageView!
    @IBOutlet weak var churchName : UILabel!
    @IBOutlet weak var denomination: UILabel!
    @IBOutlet weak var churchType: UILabel!
    @IBOutlet weak var serviceTime: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        churchImage.image = UIImage(named: "dummyphoto.png")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCellInfo(indexPath:NSIndexPath) {
        let church = data.results[indexPath.row] as Church
        churchName.text = church.name ?? "[No Title]"
        denomination.text = church.denom ?? "[No Denomination]"
        churchType.text = church.style ?? "[No Type]"
        serviceTime.text = church.times ?? "[No Times]"
        distance.text = getDistanceString(church)
        
        churchImage.file = church.img
        churchImage.loadInBackground()
    }
    
    
    func setCellInfoBookmark(indexPath:NSIndexPath) {
        let church = data.bookmarks[indexPath.row] as Church
        churchName.text = church.name ?? "[No Title]"
        denomination.text = church.denom ?? "[No Denomination]"
        churchType.text = church.style ?? "[No Type]"
        serviceTime.text = church.times ?? "[No Times]"
        distance.text = getDistanceString(church)
        
        churchImage.file = church.img
        churchImage.loadInBackground()
    }
    
    
}