/*
 Copyright 2016 Serious Llama and Grove City College. All rights reserved.
 
 Author: Charlie Mathews
 Created: 4/10/16
 */


import Foundation
import UIKit

class FiltersViewController: UITableViewController {
    
    //var filterLabels : [String] = ["Denomination", "Worship Style", "Size"]
    var filterTypes = data.filterTypes
    var filterData = data.filterData
    
    //currently selected values
    var filterSelected : Dictionary<String, AnyObject> = data.currentParameters    // currently selected values
    var filterTimes : [Int] = [0, 0]                            // currently selected times
    
    //toggle option
    var filterByServiceTime : Bool = false
    
    var current_row = 0
    var current_section = 0
    
    @IBAction func clearFilters(sender: AnyObject) {
        //viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?{
        
        current_row = indexPath.row
        current_section = indexPath.section
        
        return indexPath
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.section == 0) {
            
            
            // choose segue by row/filter
            self.performSegueWithIdentifier("listFilterSegue", sender: self)
            
        } else {
            
        }
        
        /*
         selectedFilterRow = indexPath.row
         let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! FilterViewCell
         selectedFilter = currentCell.cellName
         self.performSegueWithIdentifier("specificFilterSegue", sender: self)
         */
    }
    
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "genericFilterSegue") {
            
            //not setup
            
        } else if(segue.identifier == "listFilterSegue") {
            
            //let enumeration = Array(filterData.values)[current_row]
            let enumeration = filterData[Array(filterTypes.keys)[current_row]]
            print(enumeration)
            
        } else if(segue.identifier == "timeFilterSegue") {
            
            //
            
        }
        
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if(section == 0) { // denomination, worship style, size
            return filterData.count
        } else if (section == 1) {
            
            if(filterByServiceTime == true) {
                return 3 // time question, as early as, as late as
            } else {
                return 1 // time question
            }
            
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Search Criteria"
        } else if section == 1 {
            return "Service Times"
        } else {
            return "undefined"
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> FilterViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("filterCell", forIndexPath: indexPath) as! FilterViewCell
        
        if(indexPath.section == 0) {
        
            let name = Array(filterTypes.values)[indexPath.row]
            let value = data.currentParameters[Array(filterTypes.keys)[indexPath.row]] as! String
        
            cell.filter_name.text = name
            cell.filter_value.text = value
            
        } else {
            
            // filter by time stuff
        }

        return cell
    }
}
