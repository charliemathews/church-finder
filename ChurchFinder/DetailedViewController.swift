//
//  ViewController.swift
//  DetailedView
//
//  Created by Sam Gill on 2/4/16.
//  Copyright © 2016 SeriousLlama. All rights reserved.
//

import UIKit
import MapKit


protocol detailedViewDelegate{
    func done(child:DetailedViewController)
}

class DetailedViewController: UIViewController {
    
    var church : ChurchOld = ChurchOld(id: "", name: "")
    
    var bookmarked: Bool = false
    var delegate:detailedViewDelegate!
    
    @IBOutlet var churchViewImage : UIImageView!
    
    @IBOutlet weak var bookMarkIcon : UIButton!
    
    @IBOutlet var distanceLabel : UILabel!
    @IBOutlet var namesLabel : UILabel!
    @IBOutlet var denominationLabel : UILabel!
    @IBOutlet weak var churchMap: MKMapView!
    @IBOutlet weak var worshipStyleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var websiteLinkLabel: UILabel!
    @IBOutlet weak var websiteIcon: UIImageView!
    
    //map stuff
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        churchMap.setRegion(coordinateRegion, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        churchViewImage.image = UIImage(named: "churches.jpg")
        distanceLabel.text = "5 mi"
        namesLabel.text = church.name
        denominationLabel.text = church.denom
        worshipStyleLabel.text = church.style
        timeLabel.text = church.times
        addressLabel.text = church.address
        descriptionLabel.text = church.descr
        
        //Website setup
        let tap = UITapGestureRecognizer(target: self, action: Selector("openChurchWebsite"))
        websiteLinkLabel.addGestureRecognizer(tap)
        websiteLinkLabel.userInteractionEnabled = true
        
        websiteIcon.userInteractionEnabled = true
        websiteIcon.addGestureRecognizer(tap)
        
        
        
        //map stuff
        let initialLocation = CLLocation(latitude: (church.location?.latitude)!, longitude: (church.location?.longitude)!)
        centerMapOnLocation(initialLocation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func toggleBookMark() {
        if bookmarked {
            bookMarkIcon.setImage(UIImage(named: "star-xxl.png"), forState: .Normal)
        }
        else {
            bookMarkIcon.setImage(UIImage(named: "star-512.png"), forState: .Normal)
        }
       
        bookmarked = !bookmarked
    }
    
    func openChurchWebsite() {
        if let url = NSURL(string: church.url!) {
            
            if UIApplication.sharedApplication().canOpenURL(url) == false {
                let alertController = UIAlertController(title: "Error", message: "This website doesn't exist", preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                presentViewController(alertController, animated: true, completion: nil)
            }
            
            
            UIApplication.sharedApplication().openURL(url)
        }
    }
    @IBAction func done(sender: AnyObject) {
        delegate.done(self)
    }
}