/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Dan Mitchell
*/

import UIKit
import MapKit
import ParseUI
import QuartzCore

class ChurchListCell: UITableViewCell {

    @IBOutlet weak var churchImage: PFImageView!
    @IBOutlet weak var churchName : UILabel!
    @IBOutlet weak var denomination: UILabel!
    @IBOutlet weak var churchType: UILabel!
    @IBOutlet weak var serviceTime: UILabel!
    @IBOutlet weak var distance: UILabel! // <-- This needs to be removed. Not in the spec!
    @IBOutlet weak var distanceAddr: UILabel!
    
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
        displayInfo(church)
    }
    
    
    func setCellInfoBookmark(indexPath:NSIndexPath) {
        let church = data.bookmarks[indexPath.row] as Church
        displayInfo(church)
    }
    
    func displayInfo(church: Church) {
        churchName.text = church.name ?? "[No Title]"
        denomination.text = church.denom ?? "[No Denomination]"
        churchType.text = church.style ?? "[No Type]"
        serviceTime.text = church.times ?? "[No Times]"
        distance.text = getDistanceString(church)
        
        churchImage.file = church.img
        churchImage.loadInBackground()
        
        churchName.shadowColor = UIColor.blackColor()
        denomination.shadowColor = UIColor.blackColor()
        churchType.shadowColor = UIColor.blackColor()
        serviceTime.shadowColor = UIColor.blackColor()
        distanceAddr.shadowColor = UIColor.blackColor()
        
        churchName.shadowOffset = CGSizeMake(1,1)
        denomination.shadowOffset = CGSizeMake(1,1)
        churchType.shadowOffset = CGSizeMake(1,1)
        serviceTime.shadowOffset = CGSizeMake(1,1)
        distanceAddr.shadowOffset = CGSizeMake(1,1)
    }
}