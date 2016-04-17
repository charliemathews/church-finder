/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Dan Mitchell
*/

import UIKit
import MapKit
import Parse

class ListViewController: UITableViewController {
    
    let churchCellIdentifier = "ChurchListCell"
    @IBOutlet var table: UITableView!
    var current = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadObservers()
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.sharedInstance.results.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> ChurchListCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChurchListCell", forIndexPath: indexPath) as! ChurchListCellWithStar
        
        cell.star.alpha = 0.0
        
        for c in data.bookmarks {
            if(data.results[indexPath.row].id == c.id) {
                cell.star.alpha = 0.8
            }
        }
        
        cell.setCellInfo(indexPath.row)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        current = indexPath.row
        return indexPath
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        var bookmarkAction : UITableViewRowAction
        var backgroundColor = UIColor.blueColor()
        var title : String = "Save"
        
        for c in data.bookmarks {
            if(data.results[indexPath.row].id == c.id) {
                backgroundColor = UIColor.redColor()
                title = "Unsave"
                break
            }
        }
        
        if(title == "Save") {
            bookmarkAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: title , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                //print("Adding bookmark.")
                data.addBookmark(Data.sharedInstance.results[indexPath.row])
                self.setEditing(false, animated: true)
            })
        } else {
            bookmarkAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: title , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                //print("Removing bookmark.")
                data.removeBookmark(Data.sharedInstance.results[indexPath.row])
                self.setEditing(false, animated: true)
            })
        }
        
        bookmarkAction.backgroundColor = backgroundColor
        
        return [bookmarkAction]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "listToDetailed") {
            
            let dest = segue.destinationViewController as! DetailedViewController
            dest.church = data.results[current]
            dest.creator = "list"
        }
    }
    
    func loadObservers() {
        data.addObserver(self, forKeyPath: "bookmarks_count", options: Constants.KVO_Options, context: nil)
        data.addObserver(self, forKeyPath: "times_received", options: Constants.KVO_Options, context: nil)

    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        //print("List/Map: I sense that value of \(keyPath) changed to \(change![NSKeyValueChangeNewKey]!)")
        
        if(keyPath == "times_received" && data.times_received == data.results.count) {
            
            print("List/Map: \(data.times_received) church's service times found. Reloading views.")
            table.reloadData()
        }
        
        if(keyPath == "bookmarks_count") {
            print("List/Map: Bookmarks changed. Reloading.")
            
            //if any of the cells have a star alpha higher than 0 and they are in bookmarks, reload that cell
            //let indexPathToReload = NSIndexPath(forRow: 1, inSection: 2)
            //self.tableView.reloadRowsAtIndexPaths([indexPathToReload], withRowAnimation: UITableViewRowAnimation.Fade)
            
            table.reloadData()
        }
    }
    
    deinit {
        data.removeObserver(self, forKeyPath: "bookmarks_count", context: nil)
        data.removeObserver(self, forKeyPath: "times_received", context: nil)
    }
}
