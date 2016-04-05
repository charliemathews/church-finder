//
//  BookmarksBarViewController.swift
//  ChurchFinder
//
//  Created by Daniel Mitchell on 4/4/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//

import UIKit

class BookmarksBarViewController: UIViewController {
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func EditButton(sender: AnyObject) {
        let tv = self.childViewControllers.last as! BookmarksViewController
        tv.editing = !tv.editing
        if (tv.editing) {
            editButton.title = "Done"
        } else {
            editButton.title = "Edit"
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
