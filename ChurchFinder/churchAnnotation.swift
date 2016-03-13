//
//  churchAnnotation.swift
//  ChurchFinder
//
//  Created by Sarah Burgess on 3/12/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//

import Foundation
import MapKit

class churchAnnotation: NSObject, MKAnnotation {
    let title: String?
    let times: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, times: String,coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.times = times
        self.coordinate = coordinate
        
        super.init()
    }
    
    class func fillAnnotations(ch:Church) -> churchAnnotation {
        
        let title = ch.name
        let times = ch.times
        
        // 2
        let latitude = ch.location.latitude
        let longitude = ch.location.longitude
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        // 3
        return churchAnnotation(title: title, times: times, coordinate: coordinate)
    }
    var subtitle: String? {
        return times
    }
}