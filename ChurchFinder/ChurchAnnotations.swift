/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Sarah Burgess
Created: 03/12/16
*/

import Foundation
import MapKit

class churchAnnotation: NSObject, MKAnnotation {
    let title: String?
    let times: String
    let church: Church
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, times: String, church: Church, coordinate:CLLocationCoordinate2D) {
        self.title = title
        self.times = times
        self.coordinate = coordinate
        self.church = church
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
        return churchAnnotation(title: title, times: times, church: ch, coordinate: coordinate)
    }
    var subtitle: String? {
        return times
    }
}