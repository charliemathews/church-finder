/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Dan Mitchell
*/

import UIKit
import MapKit
import Parse
import WatchConnectivity

class ListViewController: UITableViewController,WCSessionDelegate {
    
    var wsession: WCSession?
    let churchCellIdentifier = "ChurchListCell"
    @IBOutlet var table: UITableView!
    var current = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadObservers()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //wc
        if(WCSession.isSupported()){
            wsession = WCSession.defaultSession()
            wsession!.delegate = self
            wsession!.activateSession()
        }
        var churchBookmarkedNames = [""]
        var bookmarkedChurches = [MiniChurch()]
        for b in Data.sharedInstance.bookmarks {
            churchBookmarkedNames.append(b.name)
            let newC = MiniChurch()
            newC.name = b.name
            newC.denom = b.denom
            newC.style = b.style
            newC.times = b.times
            newC.address = b.address
            newC.lat = b.location.latitude
            newC.long = b.location.longitude
            newC.phone = b.phone
            newC.times = b.times
            bookmarkedChurches.append(newC)
        }
        
        var message = [[""]]
        for(_,church) in bookmarkedChurches.enumerate() {
            message.append([church.name,church.denom,church.style,String(church.size), church.address, String(church.lat),String(church.long),church.phone,church.times])
        }
        if(message.count > 0){
            do {
                try wsession?.updateApplicationContext(
                    ["Array1" : message]
                )
            } catch let error as NSError {
                NSLog("Updating the context failed: " + error.localizedDescription)
            }
        }

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
       //wc
       
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
        if(WCSession.isSupported()){
            wsession = WCSession.defaultSession()
            wsession!.delegate = self
            wsession!.activateSession()
        }
        var churchBookmarkedNames = [""]
        var bookmarkedChurches = [MiniChurch()]
        for b in Data.sharedInstance.bookmarks {
            churchBookmarkedNames.append(b.name)
            let newC = MiniChurch()
            newC.name = b.name
            newC.denom = b.denom
            newC.style = b.style
            newC.times = b.times
            newC.address = b.address
            newC.lat = b.location.latitude
            newC.long = b.location.longitude
            newC.phone = b.phone
            newC.times = b.times
            bookmarkedChurches.append(newC)
        }
        
        var message = [[""]]
        for(_,church) in bookmarkedChurches.enumerate() {
            message.append([church.name,church.denom,church.style,String(church.size), church.address, String(church.lat),String(church.long),church.phone,church.times])
        }
        if(message.count > 0){
            do {
                try wsession?.updateApplicationContext(
                    ["Array1" : message]
                )
            } catch let error as NSError {
                NSLog("Updating the context failed: " + error.localizedDescription)
            }
        }

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
        //data.addObserver(self, forKeyPath: "results_filtered_by_time", options: Constants.KVO_Options, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        //print("List/Map: I sense that value of \(keyPath) changed to \(change![NSKeyValueChangeNewKey]!)")
        
        if(keyPath == "times_received" && data.times_received == data.results.count && data.results.count > 0 && data.threadQueryLock == false) {
            
            print("List/Map: \(data.times_received) church's service times found. Reloading views.")
            data.restrictResultsByTime()
            table.reloadData()
        } else if(keyPath == "bookmarks_count") {
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
        //data.removeObserver(self, forKeyPath: "results_filtered_by_time", context: nil)
    }
}
