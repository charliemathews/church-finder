/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Charlie Mathews
Created: 21/02/16

Sources
http://stackoverflow.com/questions/26252233/global-constants-file-in-swift
*/

import Foundation
import Parse

let data = Data.sharedInstance // THIS-> "data", NOT THIS-> "Data.sharedInstance"

struct Constants {
    
    struct Parse {
        static let AppID : String = "OTXY6dM8ChkriarqrX4SPi2e2Def9v1EM0VVNoOW"
        static let ClientKey : String = "5I1Iky8vY7hheR7X9QAejEbXaw96UMFBYGzVr4h3"
        static let MasterKey : String = "bssyoWxlPb58XACkt5TqyWMr7G4bFaFC1PdlzXdD"
        static let ChurchClass : String = "Church"
    }
    
    // These default search parameters are used by ChurchData to populate itself when it's first created and also by the filters as the default selection.
    struct Defaults {
        static let Denomination : String = ""
        static let Style : String = ""
        static let Size : Int = 0 // 0 means any size
        static let Lat : Double = 41.157838
        static let Lon : Double = -80.088670
        
        static func get() -> [String:AnyObject] {
            
            var params : [String:AnyObject] = [:]
            
            params["loc"] = PFGeoPoint(latitude: Lat, longitude: Lon)
            
            return params
        }
        
        static let NumberOfResultsToPullAtOnce : Int = 10
    }
    
}




/* Everything below this line needs to be removed. Colors may be fine. Functions should be in the views and params is unnecessary. */





var params : [String:AnyObject] = [:]

func getDistanceString(church : Church) -> String {
    if let currentLocation = Data.sharedInstance.locationManager.location {
        let churchLoc = CLLocation(latitude: church.location.latitude, longitude: church.location.longitude)
        
        //convert to miles
        let churchDistance = (currentLocation.distanceFromLocation(churchLoc) * 0.000621371)
        
        
        //if less than ten show one decimal point
        if (churchDistance < 10.0) {
            //rounding formula http://stackoverflow.com/questions/27338573/rounding-a-double-value-to-x-number-of-decimal-places-in-swift
            return String(round(churchDistance * 10)/10) + " mi"
        } else {
            //if greater than ten don't show any decimal points
            return String(Int(churchDistance)) + " mi"
        }
    }
    
    //if we can't get a current location, don't display anything for distance
    return "?"
}

