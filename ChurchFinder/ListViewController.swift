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
import Parse

class ListViewController: UITableViewController, CLLocationManagerDelegate, detailedViewDelegate, filterResultsDelegate, mapViewControllerDelegate {
    
    let churchCellIdentifier = "ChurchListCell"
    
    @IBOutlet var table: UITableView!
    
    var location : PFGeoPoint = PFGeoPoint()
    
    @IBOutlet var listMapSegControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Start Location Services
        data.locationManager.delegate = self
        data.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        data.locationManager.requestWhenInUseAuthorization()
        data.locationManager.startUpdatingLocation()
        
        data.pullResults(Constants.Defaults.get())
        
        listMapSegControl.selectedSegmentIndex = 0
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        //Data.sharedInstance.pullResults(Constants.Defaults.get())
        table.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Location services
    
    func locationManager(manager:CLLocationManager,didUpdateLocations locations: [CLLocation]){
        location = PFGeoPoint(location: locations.last)
        manager.stopUpdatingLocation()
        
        Data.sharedInstance.pullResults(Constants.Defaults.get())
        table.reloadData()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print("Errors: " + error.localizedDescription)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.sharedInstance.results.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> ChurchListCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChurchListCell", forIndexPath: indexPath) as! ChurchListCell
        
        // Configure the cell...
        cell.setCellInfo(indexPath)
        
        return cell
    }
    
    //MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "detailedChurchSegue") {
            
            let table : [UITableViewCell] = tableView.visibleCells
            
            var index : Int = 0
            for (var i = 0; i < table.count; i++) {
                if ( table[i].selected) {
                    index = i
                    break
                }
                
            }
            
            let dest = segue.destinationViewController as! DetailedViewController
            
            dest.church = Data.sharedInstance.results[index]
        }
        else if(segue.identifier == "filterViewSegue") {
            let child = segue.destinationViewController as! FilterTableViewController
            child.delegate = self
        }
        else if(segue.identifier == "mapViewSegue"){
            let child = segue.destinationViewController as! MapViewController
            child.delegate = self
        }
    }
    
    func done(vc: DetailedViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func doneWithMapView(child: MapViewController) {
        dismissViewControllerAnimated(true, completion: nil)
        listMapSegControl.selectedSegmentIndex = 0
    }
    func doneWithFilters(child: FilterTableViewController){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func cancel(segue :UIStoryboardSegue) {
        NSLog("Got rid of him.")
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
     
        let bookmark = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Bookmark" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            Data.sharedInstance.addBookmark(indexPath.row)
        })
        // 3
        bookmark.backgroundColor = UIColor.blueColor()
        
        //let bookmarkImage: UIImage = UIImage(named: "star-xxl.png")!
        
        //let newBookMarkImage = resizeImage(bookmarkImage, newWidth: 118)
        
        //bookmark.backgroundColor = UIColor(patternImage: newBookMarkImage)
        
        // 5
        return [bookmark]
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
