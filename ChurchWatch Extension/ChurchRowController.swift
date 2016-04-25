//
//  ChurchRowController.swift
//  ChurchFinder
//
//  Created by Sarah Burgess on 4/10/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//

import WatchKit

class ChurchRowController: NSObject {
    @IBOutlet var ChurchName: WKInterfaceLabel?
    var name: String? {
        didSet {
            if let name = name {
                ChurchName!.setText(name)
            }
        }
    }
    /*var church: Church? {
        didSet {
            if let church = church {
                ChurchName!.setText(church.name)
            }
        }
    }*/
}