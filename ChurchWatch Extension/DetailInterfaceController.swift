//
//  DetailInterfaceController.swift
//  ChurchFinder
//
//  Created by Sarah Burgess on 4/12/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//

import WatchKit
import Foundation


class DetailInterfaceController: WKInterfaceController {

    @IBAction func go() {
         presentControllerWithName("Map", context: curChurch)
    }

    @IBOutlet var addressLabel: WKInterfaceLabel!
    @IBOutlet var timesLabel: WKInterfaceLabel!
    @IBOutlet var styleLabel: WKInterfaceLabel!
    @IBOutlet var denomLabel: WKInterfaceLabel!
    @IBOutlet var nameLabel: WKInterfaceLabel!
    var curChurch = MiniChurch()
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if let church = context as? MiniChurch {
            nameLabel.setText(church.name)
            timesLabel.setText(church.times)
            styleLabel.setText(church.style)
            addressLabel.setText(church.address)
            denomLabel.setText(church.denom)
            curChurch = church
        }
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
