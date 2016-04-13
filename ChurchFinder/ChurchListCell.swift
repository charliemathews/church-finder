/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Dan Mitchell
*/

import UIKit
import MapKit
import ParseUI
//import QuartzCore

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
        
        if(church.times_set.count == 0) {
            
            serviceTime.text = "No service times."
            
        } else {
            
            var times : String = ""
            let sets = church.times_set
            
            for set in sets {
                for (d,t) in set {
                    let h : Int = t/60
                    let m : Int = t%60
                    
                    var m_formatted : String
                    if(m == 0) {
                        m_formatted = "00"
                    } else {
                        m_formatted = String(m)
                    }
                    
                    times += "\(d) \(h):\(m_formatted) "
                }
            }
            
            serviceTime.text = times
        }
        
        let loc = data.currentLocation
        var street = church.addr_street
        let distance : String = data.getDistance(loc, church: church)
        
        if(street == "") {
            street = "No address provided."
        }
        
        distanceAddr.text = "\(distance)mi • " + street

        if let _ = church.img?.name { //if (church.img!.name != "undefined") {
            churchImage.file = church.img
            churchImage.loadInBackground()
            self.churchImage.alpha = 0.4
            self.backgroundColor = UIColor.blackColor()
        } else {
            churchImage.image = UIImage(named: "dummyphoto.png")
            print("ListCell: \"\(church.name)\" didn't have an image. Using default instead.")
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