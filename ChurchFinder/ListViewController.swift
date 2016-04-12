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
        //data.pullResults(Constants.Defaults.get())
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
        let cell = tableView.dequeueReusableCellWithIdentifier("ChurchListCell", forIndexPath: indexPath) as! ChurchListCell
        
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
        
        bookmark.backgroundColor = UIColor(patternImage:bookmarkImage)
        
        return [bookmark]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "listToDetailed") {
            
            let dest = segue.destinationViewController as! DetailedViewController
            //dest.church = data.results[current]
        }
    }
    
    func loadObservers() {
        data.addObserver(self, forKeyPath: "success", options: Constants.KVO_Options, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        NSLog("List view senses that value of \(keyPath) changed to \(change![NSKeyValueChangeNewKey]!)")
        
        if(keyPath == "success") {
            table.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
    }
    
    deinit {
        data.removeObserver(self, forKeyPath: "success", context: nil)
    }
}
