//
//  MapInterfaceController.swift
//  ChurchFinder
//
//  Created by Sarah Burgess on 4/13/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//

import WatchKit
import Foundation


class MapInterfaceController: WKInterfaceController {
    @IBOutlet var churchlabel: WKInterfaceLabel!

    @IBOutlet var mapv: WKInterfaceMap!
    var curChurch = MiniChurch()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if let church = context as? MiniChurch {
            curChurch = church
        }
        let mapLocation = CLLocationCoordinate2DMake(curChurch.lat,curChurch.long)
        let span = MKCoordinateSpanMake(0.005, 0.005)
        mapv.setRegion(MKCoordinateRegion(center: mapLocation, span: span))
        mapv.addAnnotation(mapLocation, withPinColor:WKInterfaceMapPinColor.Red)
        churchlabel.setText(curChurch.name)
        
    
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
