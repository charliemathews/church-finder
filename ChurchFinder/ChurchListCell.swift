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


class ChurchListCell: UITableViewCell {

    @IBOutlet weak var churchImage: UIImageView!
    @IBOutlet weak var churchName : UILabel!
    @IBOutlet weak var denomination: UILabel!
    @IBOutlet weak var churchType: UILabel!
    @IBOutlet weak var serviceTime: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func makeSegue(sender: AnyObject) {
       
      
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCellInfo(indexPath:NSIndexPath) {
        let church = Data.sharedInstance.results[indexPath.row] as Church
        churchName.text = church.name ?? "[No Title]"
        denomination.text = church.denom ?? "[No Denomination]"
        churchType.text = church.style ?? "[No Type]"
        serviceTime.text = church.times ?? "[No Times]"
        
        distance.text = getDistanceString(church)
        
        //if currentLocation not known, I'm guessing that means they just didn't give us their location...
        
        churchImage.image = darkenImage(UIImage(named: "churches.jpg")!)
        
    }
    
    
    func setCellInfoBookmark(indexPath:NSIndexPath) {
        let church = Data.sharedInstance.bookmarks[indexPath.row] as Church
        churchName.text = church.name ?? "[No Title]"
        denomination.text = church.denom ?? "[No Denomination]"
        churchType.text = church.style ?? "[No Type]"
        serviceTime.text = church.times ?? "[No Times]"
        distance.text = getDistanceString(church)
        
        churchImage.image = darkenImage(UIImage(named: "churches.jpg")!)

    }
    
    
}