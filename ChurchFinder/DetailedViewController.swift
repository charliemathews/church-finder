/*
 Copyright 2016 Serious Llama and Grove City College. All rights reserved.
 
 Author: Sam Gill & Charlie Mathews
 */

import UIKit
import ParseUI

class DetailedViewController: UIViewController {
    
    var church : Church = Church()
    var creator : String = ""
    
    @IBOutlet weak var image: PFImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var denom_size: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set image
            image.contentMode = .ScaleAspectFill
            image.file = church.img
            image.loadInBackground()
        
        //set title, denomination, size, distance
            name.text = church.name
            denom_size.text = church.denom + "  •  " + String(church.size)
        
            let d : String = data.getDistance(data.currentLocation, church: church)
            distance.text = "\(d)mi"
        
        //pass other meta info to the table
            //setup meta cells
            //setup map cell
        
        //if bookmarked
            //set background circle opacity
            //set star color
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

}
