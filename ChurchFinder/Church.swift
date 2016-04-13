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
    var times_set : [[String:Int]]
    var address : String
    var addr_street     : String
    var addr_city       : String
    var addr_state      : String
    var addr_zip        : String
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
        self.times_set = [[String:Int]]()
        self.times = ""
        self.address = ""
        self.addr_street = ""
        self.addr_city = ""
        self.addr_state = ""
        self.addr_zip = ""
        self.desc = ""
        self.url = ""
        self.img = nil
    }
}