//
//  ParseBackend.swift
//  ChurchFinder
//
//  Created by Daniel Mitchell on 2/12/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//

import Parse

class Church {
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
    
    func printInfo() {
        print("id: " + id)
        print("name: " + name)
        if let v = denom {print("denomination: " + v)}
        if let v = size {print("size: " + String(v))}
        if let v = style {print("type: " + v)}
        if let v = location {print("location: " + String(v))}
        if let v = times {print("time: " + v)}
        if let v = address {print("address: " + v)}
        if let v = descr {print("description: " + v)}
        if let v = url {print("website: " + v)}
    }
}

func GrabChurchList(let geoPoint : PFGeoPoint, let start : Int, let n : Int) -> [Church] {
    let query = PFQuery(className:"Church")
    query.skip = start
    query.limit = n
    query.whereKey("loc", nearGeoPoint:geoPoint, withinMiles:10.0)
    var churchArray : [PFObject] = []
    //idk maaan
    do {
        try churchArray = query.findObjects()
    } catch {
        print("Bad Shit")
    }
    
    var churchList : [Church] = []
    
    for church in churchArray {
        let id = church.objectId
        let name = church["name"] as! String
        
        if let id = id {
            let c = Church(id: id, name: name)
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

func printCurrentChurches() {
    PFGeoPoint.geoPointForCurrentLocationInBackground {
        (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
        if error == nil {
            let churches = GrabChurchList(geoPoint!, start: 0, n: 10)
            for c in churches {
                c.printInfo()
            }
        } else {
            print("Error: \(error!) \(error!.userInfo)")
        }
    }
}
