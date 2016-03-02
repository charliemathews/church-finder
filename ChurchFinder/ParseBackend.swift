//
//  ParseBackend.swift
//  ChurchFinder
//
//  Created by Daniel Mitchell on 2/12/16.
//  Copyright © 2016 Daniel Mitchell. All rights reserved.
//

// DEPRICATED

import Parse

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
