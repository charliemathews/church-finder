/*
 Copyright 2016 Serious Llama and Grove City College. All rights reserved.
 
 Author: Charlie Mathews
 Created: 4/10/16
 */


import Foundation
import UIKit

class FiltersViewController: UITableViewController {
    
    @IBOutlet var table: UITableView!
    
    //var filterLabels : [String] = ["Denomination", "Worship Style", "Size"]
    var filterTypes = data.filterTypes
    var filterData = data.filterData
    
    //currently selected values
    var filterSelected : Dictionary<String, AnyObject> = data.currentParameters    // currently selected values
    var filterTimes : [Int] = [0, 0]                            // currently selected times
    
    var current_row = 0
    var current_section = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        print(filterSelected)
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?{
        
        current_row = indexPath.row
        current_section = indexPath.section
        
        return indexPath
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        table.deselectRowAtIndexPath(indexPath, animated: true)
        
        if(current_section == 0) {
            
            self.performSegueWithIdentifier("listFilterSegue", sender: self)
            
        } else if(current_section == 1 && current_row != 0) {
            
            self.performSegueWithIdentifier("timeFilterSegue", sender: self)
            
        } else {
        
            // do nothing
            
        }
    }
    
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let dest = segue.destinationViewController
        
        if(segue.identifier == "genericFilterSegue") {
            
            //not setup
            
        } else if(segue.identifier == "listFilterSegue") {
            
            let landing = dest as! FilterByListController
            let enumeration = filterData[Array(filterTypes.keys)[current_row]]
            
            landing.enumeration = enumeration as! [String]
            landing.name = Array(filterTypes.values)[current_row]
            
            
        } else if(segue.identifier == "timeFilterSegue") {
            
            if(current_row == 2) {
                let landing = dest as! FilterByTimeController
                landing.days.append("-")
            }
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
            
            if(data.filterByTime == false) {
                return 1
            } else {
                return 3
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

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0) {
        
            let cell = tableView.dequeueReusableCellWithIdentifier("filterCell", forIndexPath: indexPath) as! FilterViewCell
            
            let name = Array(filterTypes.values)[indexPath.row]
            let column_name = Array(filterTypes.keys)[indexPath.row]
            
            var value : String
            if let v = filterSelected[column_name] as? String {
                value = v
            } else {
                value = "Any"
            }
        
            cell.filter_name.text = name
            cell.filter_value.text = value
            
            return cell
            
        } else if indexPath.section == 1 {
            
            if(indexPath.row == 0) {
                let cell = tableView.dequeueReusableCellWithIdentifier("timesToggleCell", forIndexPath: indexPath) as! FilterTimesToggleCell
                
                if(data.allTimes.count > 0) {
                    cell.toggle.on = data.filterByTime
                } else {
                    cell.toggle.on = false
                }
                
                return cell
            } else if(indexPath.row == 1) {
                let cell = tableView.dequeueReusableCellWithIdentifier("filterCell", forIndexPath: indexPath) as! FilterViewCell
                
                cell.filter_name.text = "from"
                
                if var times = filterSelected["times"] as? [String:AnyObject] {
                    
                    let day : String = times["day"] as! String
                    let t : Int = times["start"] as! Int
                    var hour : Int = t/60
                    let min : Int = t%60
                    var period : String = ""
                    
                    if(hour > 12) {
                        period = "PM"
                        hour -= 12
                    } else {
                        period = "AM"
                    }
                    
                    var h : String = String(hour)
                    var m : String = String(min)
                    
                    if(m == "0") {
                        m = "00"
                    }
                    if(h == "0") {
                        h = "00"
                    }
                    
                    cell.filter_value.text = "\(day) \(h):\(m) \(period)"
                    
                } else {
                    
                    cell.filter_value.text = "00:00 AM"
                }
                
                return cell
            } else if(indexPath.row == 2) {
                let cell = tableView.dequeueReusableCellWithIdentifier("filterCell", forIndexPath: indexPath) as! FilterViewCell
                
                cell.filter_name.text = "to"
                
                if var times = filterSelected["times"] as? [String:AnyObject] {
                    
                    //let day : String = times["day"] as! String
                    let t : Int = times["end"] as! Int
                    var hour : Int = t/60
                    let min : Int = t%60
                    var period : String = ""
                    
                    if(hour > 12) {
                        period = "PM"
                        hour -= 12
                    } else {
                        period = "AM"
                    }
                    
                    var h : String = String(hour)
                    var m : String = String(min)
                    
                    if(m == "0") {
                        m = "00"
                    }
                    if(h == "0") {
                        h = "00"
                    }
                    
                    cell.filter_value.text = "\(h):\(m) \(period)"
                    
                } else {
                    
                    cell.filter_value.text = "00:00 AM"
                }
                
                return cell
            } else {
                return tableView.dequeueReusableCellWithIdentifier("filterCell", forIndexPath: indexPath)
            }
            
        } else {
            return tableView.dequeueReusableCellWithIdentifier("filterCell", forIndexPath: indexPath)
        }
    }
    
    @IBAction func doneWithList(segue: UIStoryboardSegue) {
        let sender = segue.sourceViewController as! FilterByListController
        
        let key = Array(filterTypes.keys)[current_row]
        let newValue = sender.selection
        
        updateSelected(key, v: newValue)
    }
    
    @IBAction func unwindFromTime(segue: UIStoryboardSegue) {
    
        let sender = segue.sourceViewController as! FilterByTimeController
        
        let day = sender.days[sender.selected[0]]
        let hour = sender.hours[sender.selected[1]]
        let min = sender.mins[sender.selected[2]]
        let period = sender.period[sender.selected[3]]
        
        print("Filters received \(day) \(hour):\(min) \(period).")

        if(current_row == 1) { // from
            
            if var times = filterSelected["times"] as? [String:AnyObject] {
                
                var t = (hour*60)+min
                if(period == "PM") {
                    t = (hour*60)+(12*60)+min
                }
                
                let range_end : Int = times["end"] as! Int
                if(range_end < t) {
                    times["end"] = t
                }
                
                times["day"] = day
                times["start"] = t
                filterSelected["times"] = times
            }
            
        } else if(current_row == 2) { // to
            
            if var times = filterSelected["times"] as? [String:AnyObject] {
                
                let range_start = times["start"] as! Int
                var range_end = (hour*60)+min
                
                if(period == "PM") {
                    range_end = (hour*60)+(12*60)+min
                }
                
                if(range_end < range_start) {
                    times["end"] = range_start
                } else {
                    times["end"] = range_end
                }
                
                filterSelected["times"] = times
            }
        }
        
        let from : NSIndexPath = NSIndexPath(forRow: 1, inSection: 1)
        let to : NSIndexPath = NSIndexPath(forRow: 2, inSection: 1)
        table.reloadRowsAtIndexPaths([from, to], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func updateSelected(k : String, v : String) {
        print("Filters will update \(k) with value \(v).")
        filterSelected[k] = v
        table.reloadData()
    }
    
    @IBAction func clearAll(sender: AnyObject) {
        
        for (k,_) in filterTypes {
            if filterSelected[k] != nil {
                self.filterSelected[k] = "Any"
            }
        }
        
        data.filterByTime = false
        filterSelected["times"] = Constants.Defaults.get()["times"]
        
        print("Resetting filters to default.")
        table.reloadData()
    }

    @IBAction func toggleFlipped(sender: AnyObject) {
        
        if(data.allTimes.count > 0) {
            data.filterByTime = !data.filterByTime
            table.reloadData()
        } else {
            data.filterByTime = false
            table.reloadData()
            let alert = UIAlertController(title: "Whoops!", message: "None of the churches in our database seem to have any service times listed at the moment.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        if var times = filterSelected["times"] as? [String:AnyObject] {
            
            times["enabled"] = Int(data.filterByTime)
            filterSelected["times"] = times
        }
    }
}
