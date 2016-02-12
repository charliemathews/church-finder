//
//  ViewController.swift
//  DetailedView
//
//  Created by Sam Gill on 2/4/16.
//  Copyright © 2016 SeriousLlama. All rights reserved.
//

import UIKit
import MapKit


struct ChurchInfo {
    
    init(name: String, denom: String, time: String, worship: String, description: String, address: String, image: UIImage, url: String) {
        self.name = name
        self.denom = denom
        self.time = time
        self.worship = worship
        self.description = description
        self.address = address
        self.image = image
        self.url = url
    }
    
    var name : String
    var denom : String
    var time : String
    var worship : String
    var description : String
    var address : String
    var image : UIImage
    var url : String
}

class DetailViewController: UIViewController {
    
    var bookmarked: Bool = false
    
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
    
    
    var church = ChurchInfo(name: "Chapel", denom: "Presbyterian", time: "9:30", worship: "Contemporary", description: "This is the description section about the church", address: "100 Campus Dr.", image: UIImage(named: "churches.jpg")!, url: "www.SeriousLlama.com")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        churchViewImage.image = UIImage(named: "churches.jpg")
        distanceLabel.text = "5 mi"
        namesLabel.text = church.name
        denominationLabel.text = church.denom
        worshipStyleLabel.text = church.worship
        timeLabel.text = church.time
        addressLabel.text = church.address
        descriptionLabel.text = church.description
        
        
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
        let url = NSURL(string: church.url)!
        UIApplication.sharedApplication().openURL(url)
    }
}