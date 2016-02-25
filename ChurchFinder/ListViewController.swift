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

class ListViewController: UITableViewController, CLLocationManagerDelegate, detailedViewDelegate {
    
    let churchCellIdentifier = "ChurchListCell"
    
    @IBOutlet var table: UITableView!
    
    
    
    
    var location : PFGeoPoint = PFGeoPoint()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Start Location Services
        Globals.sharedInstance.locationManager.delegate = self
        Globals.sharedInstance.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        Globals.sharedInstance.locationManager.requestWhenInUseAuthorization()
        Globals.sharedInstance.locationManager.startUpdatingLocation()
        
        if Globals.sharedInstance.churchList.count == 0 {
            Globals.sharedInstance.churchList = GrabChurchList(0, n: 5)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Location services
    
    func locationManager(manager:CLLocationManager,didUpdateLocations locations: [CLLocation]){
        location = PFGeoPoint(location: locations.last)
        manager.stopUpdatingLocation()
        //Globals.sharedInstance.churchList = GrabChurchList(location, start: 0, n: 5)
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
        return Globals.sharedInstance.churchList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> ChurchListCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChurchListCell", forIndexPath: indexPath) as! ChurchListCell
        // Configure the cell...
        setTitleForCell(cell, indexPath: indexPath)
        return cell
    }
    
    func setTitleForCell(cell:ChurchListCell, indexPath:NSIndexPath) {
        let church = Globals.sharedInstance.churchList[indexPath.row] as ChurchOld
        cell.churchName.text = church.name ?? "[No Title]"
        cell.denomination.text = church.denom ?? "[No Denomination]"
        cell.churchType.text = church.style ?? "[No Type]"
        cell.serviceTime.text = church.times ?? "[No Times]"
        cell.distance.text = "Needs work"
    }
    
    
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
            
            dest.church = Globals.sharedInstance.churchList[index]
        }
    }
    
    func done(vc: DetailedViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(segue :UIStoryboardSegue) {
        NSLog("Got rid of him.")
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        // 1
        
        
        let bookmark = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Bookmark" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            
            // 2
            //let shareMenu = UIAlertController(title: nil, message: "Share using", preferredStyle: .ActionSheet)
            
            //let twitterAction = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.Default, handler: nil)
            //let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
            //shareMenu.addAction(twitterAction)
            //shareMenu.addAction(cancelAction)
            
            
            //self.presentViewController(shareMenu, animated: true, completion: nil)
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
