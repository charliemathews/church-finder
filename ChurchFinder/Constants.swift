/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Charlie Mathews
Created: 21/02/16
Modified: 25/02/16

Changelog
* Magnificent file header was authored by codereview2k16 #squad

Sources
http://stackoverflow.com/questions/26252233/global-constants-file-in-swift
*/

import Foundation
import Parse

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
var params : [String:AnyObject] = [:]
let data = Data.sharedInstance


