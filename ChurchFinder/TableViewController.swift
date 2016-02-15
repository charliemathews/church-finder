//
//  TableViewController.swift
//  ChurchFinder
//
//  Created by Michael Curtis on 2/2/16.
//  Copyright (c) 2016 Michael Curtis. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, detailedViewDelegate {

    func done(child: DetailedViewController) {
        
    }

    let churches = ["Covenant OPC", "East Main", "Church of the Flying Spaghetti Monster"]
    let worshipStyles = ["Contemporary", "Traditional", "80's Discotech"]
    var distance: Int!
    let streets = ["123 Holy Street", "321 Grace Street", "1337 hax street"]
    let times = ["10:00 - 11:00", "11:00 - 12:00", "We end before kickoff"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return churches.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      //  var secondVC:ViewController = ViewController()
      //  secondVC = segue.destinationViewController as SecondViewController
      //  secondVC.delegate = self
        if (segue.identifier == "detailedSeg" ) {
            let dest = segue.destinationViewController as! DetailedViewController
            dest.delegate = self
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> TableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listViewCell", forIndexPath: indexPath) as! TableViewCell
        cell.denomLabel.text = churches[indexPath.row]
        cell.worshipLabel.text = worshipStyles[indexPath.row]
        cell.distanceLabel.text = "\(indexPath.row)0 Miles"
        cell.addressLabel.text = streets[indexPath.row]
        cell.timeLabel.text = times[indexPath.row]
        // Configure the cell...
        return cell
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
