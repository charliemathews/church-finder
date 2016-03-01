//
//  ParseBackend.swift
//  ChurchFinder
//
//  Created by Daniel Mitchell on 2/12/16.
//  Copyright © 2016 Daniel Mitchell. All rights reserved.
//

import Parse

class ChurchOld {
    var id : String
    var name : String
    var denom : String?
    var size : Int?
    var style : String?
    var location : PFGeoPoint?
    var times : String?
    var address : String?
    var descr : String?
    var url : String?
    
    init(let id : String, let name : String) {
        self.id = id
        self.name = name
    }
}

func GrabChurchList(let geoPoint : PFGeoPoint, let start : Int, let n : Int) -> [ChurchOld] {
    let query = PFQuery(className:"Church")
    query.skip = start
    query.limit = n
    query.whereKey("loc", nearGeoPoint:geoPoint, withinMiles:100.0)
    var churchArray : [PFObject] = []
    //idk maaan
    do {
        try churchArray = query.findObjects()
    } catch {
        print("Bad Shit")
    }
    
    var churchList : [ChurchOld] = []
    
    for church in churchArray {
        let id = church.objectId
        let name = church["name"] as! String
        
        if let id = id {
            let c = ChurchOld(id: id, name: name)
            c.denom = church["denomination"] as? String
            c.size = church["size"] as? Int
            c.style = church["style"] as? String
            c.location = church["loc"] as? PFGeoPoint
            c.times = church["times"] as? String
            c.address = church["address"] as? String
            c.descr = church["description"] as? String
            c.url = church["url"] as? String
            
            churchList.append(c)
        }
    }
    
    print("Done")
    return churchList
}

func GrabChurchList(let start : Int, let n : Int) -> [Church] {
    let query = PFQuery(className:"Church")
    query.skip = start
    query.limit = n
    var churchArray : [PFObject] = []
    //idk maaan
    do {
        try churchArray = query.findObjects()
    } catch {
        print("Bad Shit")
    }
    
    var churchList : [Church] = []
    
    for church in churchArray {
            let c = Church()
            
            c.name     = church["name"]         as! String
            c.denom    = church["denomination"] as! String
            c.size     = church["size"]         as! Int
            c.style    = church["style"]        as! String
            c.location = church["loc"]          as! PFGeoPoint
            c.times    = church["times"]        as! String
            c.address  = church["address"]      as! String
            c.desc     = church["description"]  as! String
            c.url      = church["url"]          as! String
            c.object   = church
            
            churchList.append(c)
    }
    
    print("Done")
    return churchList
}
