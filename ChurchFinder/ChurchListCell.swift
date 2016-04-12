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
    
    let pi = 3.14159265358979323846
    let earthRadiusKm = 6371.0
    let MIinKM = 0.62137119
    
    func deg2rad(deg: Double) -> Double {
        return (deg * pi / 180)
    }
    
    func rad2deg(rad: Double) -> Double {
        return (rad * 180 / pi)
    }
    
    // return the distance between two coordinates in km
    func getDistance(lat1: Double, lng1: Double, lat2: Double, lng2: Double) -> Double {
        
        let lat1r = deg2rad(lat1)
        let lon1r = deg2rad(lng1)
        let lat2r = deg2rad(lat2)
        let lon2r = deg2rad(lng2)
        let u = sin((lat2r - lat1r)/2)
        let v = sin((lon2r - lon1r)/2)
        return 2.0 * earthRadiusKm * asin(sqrt(u * u + cos(lat1r) * cos(lat2r) * v * v))
    }
    
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
        
        var distance : String
        let loc = data.currentLocation
        
        if loc != Constants.Defaults.getLoc() {
            var raw = getDistance(church.location.latitude, lng1: church.location.longitude, lat2: loc.latitude, lng2: loc.longitude)
            raw *= MIinKM
            distance = String(format: "%0.1f", raw)
        } else {
            distance = "?"
        }
        distanceAddr.text = "\(distance)mi • " + church.addr_street

        if let _ = church.img?.name {
        //if (church.img!.name != "undefined") {
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