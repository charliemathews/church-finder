/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Charlie Mathews
Created: 21/02/16
Modified: 25/02/16

Changelog
* Magnificent file header was authored by codereview2k16 #squad

Tested & Passed
Unit:               {mm/dd/yy} by {last name}
Integration:        {mm/dd/yy} by {last name}

Sources:
http://krakendev.io/blog/the-right-way-to-write-a-singleton
https://parse.com/questions/retrieving-unique-values
*/

import Foundation
import Parse

class Church {
    var id      : String
    var name    : String
    var denom   : String
    var size    : Int
    var style   : String
    var location: PFGeoPoint
    var times   : String
    var address : String
    var desc    : String
    var url     : String
    var churchDictionary: [String: String] = [:]
    
    init() {
        self.id = ""
        self.name = ""
        self.denom = ""
        self.size = 0
        self.style = ""
        self.location = PFGeoPoint()
        self.times = ""
        self.address = ""
        self.desc = ""
        self.url = ""
    }
    
    init(
        let id      : String,
        let name    : String,
        let denom   : String,
        let size    : Int,
        let style   : String,
        let location: PFGeoPoint,
        let times   : String,
        let address : String,
        let desc    : String,
        let url     : String
        ) {
            
            self.id = id
            self.name = name
            self.denom = denom
            self.size = size
            self.style = style
            self.location = location
            self.times = times
            self.address = address
            self.desc = desc
            self.url = url
    }
    func mapNameToString(input: String) -> String{
        switch input{
        case "id":
            return id
        case "name":
            return name
        case "denoms":
            return denom
        case "style":
            return style
        case "times":
            return times
        case "address":
            return address
        case "desc":
            return desc
        case "url":
            return url
        default:
            return ""
        }
    }
    func mapNameToInt(input: String) -> Int{
        switch input{
            case "size":
                return size
            default:
                return -1
        }
    }
}