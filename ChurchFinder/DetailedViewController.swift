/*
 Copyright 2016 Serious Llama and Grove City College. All rights reserved.
 
 Author: Sam Gill & Charlie Mathews
 */

import UIKit
import ParseUI
import MapKit

class DetailedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var action_slot_1: UIView!
    @IBOutlet weak var action_slot_2: UIView!
    @IBOutlet weak var action_slot_3: UIView!
    
    @IBOutlet weak var action_slot_1_image: UIImageView!
    @IBOutlet weak var action_slot_2_image: UIImageView!
    @IBOutlet weak var action_slot_3_image: UIImageView!
    @IBOutlet weak var action_slot_1_text: UILabel!
    @IBOutlet weak var action_slot_2_text: UILabel!
    @IBOutlet weak var action_slot_3_text: UILabel!
    
    var church : Church = Church()
    var creator : String = ""
    var bookmarked : Bool = false
    
    let highlightedBookmarkColor: UIColor = UIColor(colorLiteralRed: 1.0, green: 0.84, blue: 0.0, alpha: 1)
    let defaultBookmarkColor: UIColor = UIColor(colorLiteralRed: 0.08235, green: 0.44313, blue: 0.98431, alpha: 1)
    let actionBackground: UIColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0)
    let actionBackground_selected: UIColor = UIColor(colorLiteralRed: 0.08235, green: 0.44313, blue: 0.98431, alpha: 0.2)
    
    // the order of these items is the order they will be displayed in the table
    var meta_candidates : [String] = []
    
    @IBOutlet weak var circle: UIImageView!
    @IBOutlet weak var star: UIButton!
    @IBOutlet weak var image: PFImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var denom_size: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // modify this based on what's available in the church object
        meta_candidates = ["style", "times", "phone", "address"]
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //set image
            image.contentMode = .ScaleAspectFill
            image.file = church.img
            image.loadInBackground()
        
        //set title, denomination, size, distance
            name.text = church.name
            denom_size.text = church.denom + " • " + String(church.size) + " people"
        
            let d : String = data.getDistance(data.currentLocation, church: church)
            distance.text = "\(d)mi"
        
        
        let i = star.imageView?.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        star.setImage(i, forState: .Normal)
        
        updateBookmarkIndicator()
        
        setTint(action_slot_1_image, tint: defaultBookmarkColor)
        setTint(action_slot_2_image, tint: defaultBookmarkColor)
        setTint(action_slot_3_image, tint: defaultBookmarkColor)
        
        action_slot_1_text.textColor = defaultBookmarkColor
        action_slot_2_text.textColor = defaultBookmarkColor
        action_slot_3_text.textColor = defaultBookmarkColor
        
        let tap_bookmark = UITapGestureRecognizer(target: self, action: #selector(DetailedViewController.toggleBookMark))
        star.userInteractionEnabled = true
        star.addGestureRecognizer(tap_bookmark)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(DetailedViewController.action_openWebsite))
        action_slot_1.userInteractionEnabled = true
        action_slot_1.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(DetailedViewController.action_navigate))
        action_slot_2.userInteractionEnabled = true
        action_slot_2.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(DetailedViewController.action_share))
        action_slot_3.userInteractionEnabled = true
        action_slot_3.addGestureRecognizer(tap3)
    }
    
    func setTint(view: UIImageView, tint: UIColor) {
        let i = view.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        view.image = i
        view.tintColor = tint
    }
    
    func toggleBookMark() {
        if bookmarked {
            Data.sharedInstance.removeBookmark(church)
        } else {
            Data.sharedInstance.addBookmark(church)
        }
        bookmarked = !bookmarked
        updateBookmarkIndicator()
    }
    
    func updateBookmarkIndicator() {
        bookmarked = Data.sharedInstance.bookmarks.contains { (Church) -> Bool in
            church.id == Church.id
        }
        
        if bookmarked {
            star.imageView?.tintColor = highlightedBookmarkColor
        } else {
            star.imageView?.tintColor = defaultBookmarkColor
        }
    }
    
    func action_call() {
        let phone : String = church.phone
        var newPhone : String = ""
        
        for i in 0..<phone.characters.count {
            let index = phone.startIndex.advancedBy(i)
            switch (phone[index]) {
            case "0","1","2","3","4","5","6","7","8","9" : newPhone = newPhone + String(phone[index])
            default : ()
            }
        }
        
        if let url = NSURL(string: "tel://\(newPhone)") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func action_openWebsite() {
        
        action_slot_1.backgroundColor = actionBackground_selected
        
        UIView.animateWithDuration(2, animations: { () -> Void in
            self.action_slot_1.backgroundColor = self.actionBackground
        })
        
        
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
    
    func action_navigate() {
        
        action_slot_2.backgroundColor = actionBackground_selected
        
        UIView.animateWithDuration(2, animations: { () -> Void in
            self.action_slot_2.backgroundColor = self.actionBackground
        })
        
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
    
    func action_share() {
        
        action_slot_3.backgroundColor = actionBackground_selected
        
        UIView.animateWithDuration(2, animations: { () -> Void in
            self.action_slot_3.backgroundColor = self.actionBackground
        })
        
        let textToShare = "Check out \(church.name) at \(church.url)!\nService Time: \(church.times)"
        
        if let myWebsite = NSURL(string: church.url) {
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
            
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func back(sender: AnyObject) {
        
        if(creator == "list") {
            performSegueWithIdentifier("searchUnwind", sender: self)
        } else if (creator == "bookmarks") {
            performSegueWithIdentifier("bookmarkUnwind", sender: self)
        } else if (creator == "map") {
            performSegueWithIdentifier("searchUnwind", sender: self)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            var count = meta_candidates.count
            if church.desc != "" {
                count += 1
            }
            return count
            
        } else if section == 1 {
            
            return 1
        } else {
            return 0
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            var identifier = "metaCell"
            if(indexPath.row >= meta_candidates.count) {
                identifier = "metaCellDesc"
            }
            
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! DetailedMetaCell
            
            var metaType : String = ""
            if(indexPath.row < meta_candidates.count) {
                metaType = meta_candidates[indexPath.row]
            }
            
            if metaType == "style" {
                cell.icon.image = UIImage(named: "music_icon.png")
                cell.value.text = church.style
            } else if metaType == "times" {
                cell.icon.image = UIImage(named: "time_icon.png")
                if(church.times_set.count == 0) {
                    
                    cell.value.text = "No service times listed."
                    
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
                    
                    cell.value.text = times
                }
                
            } else if metaType == "address" {
                cell.icon.image = UIImage(named: "compass_icon.png")
                cell.value.text = church.addr_street + ", " + church.addr_city + ", " + church.addr_state + " " + church.addr_zip
                
            } else if metaType == "phone" {
                //cell.icon.image = UIImage(named: "compass_icon.png")
                cell.value.text = church.phone
                
            } else if identifier == "metaCellDesc" && church.desc != "" {
                cell.icon.image = UIImage(named: "info_icon.png")
                cell.value.text = church.desc
            }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("mapCell", forIndexPath: indexPath) as! DetailedMapCell
            
            let loc = CLLocationCoordinate2D(latitude: church.location.latitude, longitude: church.location.longitude)
            
            let pin = MKPointAnnotation()
            pin.coordinate = loc
            pin.title = church.name
            
            cell.mapView.addAnnotation(pin)
            cell.mapView.showAnnotations(cell.mapView.annotations, animated: false)
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if(indexPath.section == 1) {
            return 200
        }
        return 44
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if(indexPath.section == 0) {
            
            if indexPath.row < meta_candidates.count {
                let metaType = meta_candidates[indexPath.row]
                if(metaType == "address") {
                    action_navigate()
                } else if(metaType == "phone") {
                    action_call()
                }
            }
        
        }
        return indexPath
    }
    
    // only enable below if we are using grouped table
    /*
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return "Info"
        } else if(section == 1) {
            return "Map"
        } else {
            return ""
        }
    }
    */
}
