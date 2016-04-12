/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Dan Mitchell
*/

import UIKit
import MapKit
import ParseUI
import QuartzCore

class ChurchListCell: UITableViewCell {

    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var churchImage: PFImageView!
    @IBOutlet weak var churchName : UILabel!
    @IBOutlet weak var denomination: UILabel!
    @IBOutlet weak var churchType: UILabel!
    @IBOutlet weak var serviceTime: UILabel!
    @IBOutlet weak var distanceAddr: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        churchImage.image = UIImage(named: "dummyphoto.png")
        churchImage.contentMode = .ScaleAspectFill
        self.churchImage.alpha = 1
        //self.backgroundColor = UIColor.whiteColor()
        //self.backgroundView?.backgroundColor = UIColor.whiteColor()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setCellInfo(resultIndex : Int) {
        let church = data.results[resultIndex] as Church
        displayInfo(church)
    }
    
    
    func setCellInfoBookmark(resultIndex : Int) {
        let church = data.bookmarks[resultIndex] as Church
        displayInfo(church)
    }
    
    func displayInfo(church: Church) {
        churchName.text = church.name ?? "[No Title]"
        denomination.text = church.denom ?? "[No Denomination]"
        churchType.text = church.style ?? "[No Type]"
        serviceTime.text = church.times ?? "[No Times]"
        
        distanceAddr.text = "0mi • " + church.address

        if let _ = church.img?.name {
        //if (church.img!.name != "undefined") {
            churchImage.file = church.img
            churchImage.loadInBackground()
            self.churchImage.alpha = 0.4
            self.backgroundColor = UIColor.blackColor()
        }
        
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