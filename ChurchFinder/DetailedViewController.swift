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
    
    var church : Church = Church(id: "", name: "")
    
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
        let url = NSURL(string: church.url!)!
        UIApplication.sharedApplication().openURL(url)
    }
    @IBAction func done(sender: AnyObject) {
        delegate.done(self)
    }
}