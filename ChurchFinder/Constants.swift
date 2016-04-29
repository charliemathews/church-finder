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
        static let Denomination : String = "Any"
        static let Style : String = "Any"
        static let Size : Int = 0 // 0 means any size
        static let Lat : Double = 41.157838
        static let Lon : Double = -80.088670
        static let Radius : Int = 30
        
        static func get() -> [String:AnyObject] {
            
            var params : Dictionary<String,AnyObject> = [:]
            
            params["denomination"] = Denomination
            params["style"] = Style
            params["size"] = "Any"
            params["loc"] = PFGeoPoint(latitude: Lat, longitude: Lon)
            
            var t : [String:AnyObject] = [:]
            t["enabled"] = false
            t["day"] = "SUN"
            t["start"] = 480
            t["end"] = 840
            
            params["times"] = t
            
            return params
        }
        
        static func getLoc() -> PFGeoPoint {
            
            return PFGeoPoint(latitude: Lat, longitude: Lon)
            
        }
        
        static let NumberOfResultsToPullAtOnce : Int = 50
    }
    
    static let KVO_Options = NSKeyValueObservingOptions([.New, .Old])
    
}
