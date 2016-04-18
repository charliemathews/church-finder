/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Dan Mitchell
*/

import UIKit

class BookmarksViewController: UITableViewController {
    
    let churchCellIdentifier = "ChurchListCell"
    var current_row = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadObservers()
        
        for i in 0..<data.bookmarks.count {
            if(data.threadQueryLock == true) { // if another query is running, we should be waiting for that query.
                break
            }
            
            var alreadyFound : Bool = false
            
            for church in data.results {
                if(church.id == data.bookmarks[i].id) {
                    alreadyFound = true
                    data.bookmarks[i].times_set = church.times_set
                    data.times_received_bookmarks += 1
                }
            }
            
            if alreadyFound == false {
                data.getTimes(i, forBookmarks: true)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.bookmarks.count
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        current_row = indexPath.row
        return indexPath
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(churchCellIdentifier, forIndexPath: indexPath) as! ChurchListCell
        cell.setCellInfoBookmark(indexPath.row)
        return cell
    }
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            data.removeBookmark(indexPath.row)
            
            tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let item = data.bookmarks[sourceIndexPath.row]
        data.bookmarks.removeAtIndex(sourceIndexPath.row)
        data.bookmarks.insert(item, atIndex: destinationIndexPath.row)
        data.writeBookmarkOrder()
    }
    
    func loadObservers() {
        data.addObserver(self, forKeyPath: "times_received_bookmarks", options: Constants.KVO_Options, context: nil)
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        //print("Bookmarks: I sense that value of \(keyPath) changed to \(change![NSKeyValueChangeNewKey]!)")
        
        
        if(keyPath == "times_received_bookmarks" && data.times_received_bookmarks == data.bookmarks.count) {
            
            tableView.reloadData()
        }
        
    }
    
    deinit {
        data.removeObserver(self, forKeyPath: "times_received_bookmarks", context: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "bookmarkToDetailed") {
            
            let dest = segue.destinationViewController as! DetailedViewController
            dest.church = data.bookmarks[current_row]
            dest.creator = "bookmarks"
        }
    }
    
    @IBAction func unwindFromDetailedToBookmarks(segue: UIStoryboardSegue){
        print("Unwound from detailed to bookmarks.")
        
    }
    
    @IBAction func cancel(segue :UIStoryboardSegue) {
        //NSLog("Got rid of him.")
    }
}
