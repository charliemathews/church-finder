/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Sam Gill
Created:
Modified: 24/02/16

Changelog
...

Sources
...
*/

import UIKit
import MapKit


protocol detailedViewDelegate {
    func done(child:DetailedViewController)
}

class DetailedViewController: UIViewController {
    
    var church : Church = Church()
    
    var bookmarked: Bool = false
    var delegate:detailedViewDelegate!
    
    
    @IBOutlet weak var directionsImage: UIImageView!
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet var churchViewImage : UIImageView!
    @IBOutlet weak var bookMarkIcon : UIButton!
    @IBOutlet weak var shareImage: UIImageView!
    @IBOutlet weak var shareLabel: UILabel!
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
        descriptionLabel.text = church.desc
        
        //Website setup
        let tap = UITapGestureRecognizer(target: self, action: Selector("openChurchWebsite"))
        
        websiteLinkLabel.userInteractionEnabled = true
        websiteLinkLabel.addGestureRecognizer(tap)
        
        let tapL = UITapGestureRecognizer(target: self, action: Selector("openChurchWebsite"))
        websiteIcon.userInteractionEnabled = true
        websiteIcon.addGestureRecognizer(tapL)
        
        //share button setup
        let tapShare = UITapGestureRecognizer(target: self,action:Selector("share"))
        shareImage.addGestureRecognizer(tapShare)
        shareImage.userInteractionEnabled = true
        
        let tapShareL = UITapGestureRecognizer(target: self,action:Selector("share"))
        shareLabel.addGestureRecognizer(tapShareL)
        shareLabel.userInteractionEnabled = true
        
        //directions button setup
        let tapDir = UITapGestureRecognizer(target: self,action:Selector("getDirections"))
        directionsImage.addGestureRecognizer(tapDir)
        directionsImage.userInteractionEnabled = true
        let tapDirL = UITapGestureRecognizer(target: self,action:Selector("getDirections"))
        directionsLabel.addGestureRecognizer(tapDirL)
        directionsLabel.userInteractionEnabled = true
        
        //map initialization
        let initialLocation = CLLocation(latitude: church.location.latitude, longitude: church.location.longitude)
        centerMapOnLocation(initialLocation)
        
        //drop pin
        let loc = CLLocationCoordinate2D(latitude: church.location.latitude, longitude: church.location.longitude)
        let pin = MKPointAnnotation()
        pin.coordinate = loc
        
        churchMap.addAnnotation(pin)
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
    
    func getDirections(){
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(church.location.latitude, church.location.longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(church.name)"
        mapItem.openInMapsWithLaunchOptions(options)
        
    }
    func share(){
        let textToShare = "Check out \(church.name) at \(church.url)!"
        
        if let myWebsite = NSURL(string: church.url) {
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
            //
            
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    func openChurchWebsite() {
        let url = NSURL(string: church.url)
        
        if url == nil || UIApplication.sharedApplication().canOpenURL(url!) == false {
            let alertController = UIAlertController(title: "Error", message: "This website doesn't exist", preferredStyle: .Alert)
            
            
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            UIApplication.sharedApplication().openURL(url!)
        }
        
        
        
        
    }
    @IBAction func done(sender: AnyObject) {
        delegate.done(self)
    }
}