/*
 Copyright 2016 Serious Llama and Grove City College. All rights reserved.
 
 Author: Sam Gill & Charlie Mathews
 */

import UIKit
import ParseUI
import MapKit

class DetailedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var church : Church = Church()
    var creator : String = ""
    
    let meta_candidates : [String] = ["style", "times", "address"]
    
    @IBOutlet weak var image: PFImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var denom_size: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            if(indexPath.row > meta_candidates.count) {
                identifier = "metaCellDesc"
            }
            
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! DetailedMetaCell
            
            let metaType = meta_candidates[indexPath.row]
        
            if metaType == "style" {
                cell.value.text = church.style
            } else if metaType == "times" {
                cell.value.text = "TIMES ARE WIP" //TO DO ONCE TIMES ARE HANDLED
            } else if metaType == "address" {
                cell.value.text = church.addr_street + ", " + church.addr_city + ", " + church.addr_state + " " + church.addr_zip
            } else if identifier == "metaCellDesc" && church.desc != "" {
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
            cell.mapView.showAnnotations(cell.mapView.annotations, animated: true)
            
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
