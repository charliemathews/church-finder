/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Sarah Burgess
Created:
Modified: 24/02/16

Changelog
...

Sources
...
*/
import Foundation
import UIKit

protocol filterResultsDelegate{
    func doneWithFilters(child: FilterTableViewController)
}

/*
TODO: pull labels, denominations, styles, etc from data model using, for ex. data.getMeta("denomination")
*/
class FilterTableViewController: UITableViewController, specificFilterViewControllerDelegate{

  
    let labels = ["Denomination", "Worship Style", "Size", "Times"]
    let denoms = data.getMeta("denomination")
    let worshipStyles = data.getMeta("style")
    let sizes = ["Small", "Medium", "Osteen"]
    let times = data.getMeta("times")
    var selectedFilter: String!
    var selectedFilterRow: Int!
    var delegate: filterResultsDelegate!
    var check: Int!
    var current = 0
    var curInd: NSIndexPath!
    
    @IBAction func clearFilters(sender: AnyObject) {
        viewDidLoad()
    }
    
    @IBAction func doneWithFilters(sender: AnyObject) {
        //delegate.doneWithFilters(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        data
    }
    func mapIndexToPickerValues(index: Int) -> [String]{
        switch (index){
        case 0:
            return denoms
        case 1:
            return worshipStyles
        case 2:
            return sizes
        case 3:
            return times
        default: return []
        }
    }
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "specificFilterSegue"){
            let dest = segue.destinationViewController as! SpecificFilterSelectViewController
            dest.delegate = self
            dest.pickerName = selectedFilter
            dest.pickerValues = mapIndexToPickerValues(selectedFilterRow)
        }
     }
    func doneWithSpecificFilter(child: SpecificFilterSelectViewController){
        //???
        params[child.pickerName] = child.selectedPickerValue
       
        selectedFilterRow = current
        let currentCell = tableView.cellForRowAtIndexPath(curInd) as! FilterViewCell
        currentCell.selectedFilterLabel!.text = child.selectedPickerValue
        currentCell.selectedFilterLabel.bringSubviewToFront(currentCell.selectedFilterLabel)
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?{
        current = indexPath.row
        curInd = indexPath
        return indexPath
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    //Note: This assigns the cellName (which in turn is used to name the churchDictionary keys) to what the name of each variable
    //in the church class is.
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> FilterViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tblCell", forIndexPath: indexPath) as! FilterViewCell
        cell.textLabel?.text = labels[indexPath.row]
        switch (indexPath.row){
            case 0:
                cell.pickerLabels = denoms
                cell.cellName = "denoms"
                break
            case 1:
                cell.pickerLabels = worshipStyles
                cell.cellName = "style"
                break
            case 2:
                cell.pickerLabels = sizes
                cell.cellName = "size"
                break
            case 3:
                cell.pickerLabels = times
                cell.cellName = "times"
                break
            default: break
        }
        cell.setSelected(true, animated: true)
        // Configure the cell...
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedFilterRow = indexPath.row
        let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! FilterViewCell
        selectedFilter = currentCell.cellName
        self.performSegueWithIdentifier("specificFilterSegue", sender: self)
    }
}
