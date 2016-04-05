/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Dan Mitchell
*/

import UIKit
import MapKit
import Parse

class ListViewController: UITableViewController, detailedViewDelegate {
    
    let churchCellIdentifier = "ChurchListCell"
    @IBOutlet var table: UITableView!
    var current = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        
        //MAY NEED CHANGING?
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        current = indexPath.row
        return indexPath
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        var bookmarkImage = UIImage(named:"bookmarkStarBlue.png")!
        
        for church in data.bookmarks {
            if(church.id == data.results[indexPath.row].id) {
                bookmarkImage = UIImage(named: "bookmarkStarRed.png")!
            }
            else {
                bookmarkImage = UIImage(named: "bookmarkStarBlue.png")!
            }
        }
        
        let bookmark = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "                    " , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            data.addBookmark(Data.sharedInstance.results[indexPath.row])
            
            //makes the cell slide back when pressed
            self.setEditing(false, animated: true)
        })
        
        // 3
        bookmark.backgroundColor = UIColor(patternImage:bookmarkImage)
        
        
        //let newBookMarkImage = resizeImage(bookmarkImage, newWidth: 118)
        
        //bookmark.backgroundColor = UIColor(patternImage: newBookMarkImage)
        
        // 5
        return [bookmark]
    }
    
    /*
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }*/
    
    //MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "listToDetailed") {
            
            let dest = segue.destinationViewController as! DetailedViewController
            
            dest.church = data.results[current]
        }
    }
    func done(vc: DetailedViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func cancel(segue :UIStoryboardSegue) {
        NSLog("Got rid of him.")
    }
}
