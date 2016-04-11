/*
 Copyright 2016 Serious Llama and Grove City College. All rights reserved.
 
 Author: Charlie Mathews
 Created: 4/11/16
 */

import UIKit

class FilterByListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var viewTitle: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    var name : String = "undefined"
    var enumeration : [String] = []
    var selection : String = "Any"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.viewTitle.title = name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return enumeration.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("list_cell", forIndexPath: indexPath) as! FilterListCell
        
        cell.data_value.text = enumeration[indexPath.row]
        
        return cell
    }

    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selection = enumeration[indexPath.row]
        return indexPath
    }
}
