//
//  Global.swift
//  ChurchFinder
//
//  Created by Daniel Mitchell on 2/23/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//
import MapKit

class Globals {
    var churchList : [Church] = []
    let locationManager = CLLocationManager()
    static let sharedInstance = Globals()
    private init() {}
}
var churchModel = Church.init()