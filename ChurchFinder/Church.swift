/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Charlie Mathews
Created: 21/02/16

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
    var img     : PFFile?
    var object  : PFObject?
    
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
        self.img = nil
    }
    
    init(
        let id      :   String,
        let name    :   String,
        let denom   :   String,
        let size    :   Int,
        let style   :   String,
        let location:   PFGeoPoint,
        let times   :   String,
        let address :   String,
        let desc    :   String,
        let url     :   String
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
}