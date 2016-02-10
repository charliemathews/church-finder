//
//  FilterViewController.swift
//  ChurchFinder
//
//  Created by Sarah Burgess on 2/8/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//

import UIKit


class FilterViewController: UIViewController {
    
    
    var delegate: filterResultsDelegate!
    var check: Int!
    
    //var cells = [FilterViewCell]()
    let tempStrArray = ["str1", "str2"]
    var cell: FilterViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        //cell = FilterViewCell()
        //cell.initialize("test", pL: tempStrArray)
        // Do any additional setup after loading the view.
        
    }
    func returnCheck()-> Int{
        return check
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func triggerDone(sender: AnyObject) {
        
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
