/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Charlie Mathews & Dan Mitchel
Created: 21/02/16

Tested & Passed
Unit:               26/02/16 by Charlie
Integration:        26/02/16 by Charlie

Sources:
http://krakendev.io/blog/the-right-way-to-write-a-singleton
https://parse.com/questions/retrieving-unique-values

This class is a singleton designed to persist behind the scenes between all views. It can be used to pull metadata for the filters and request new church results. Search parameters are stored with each query so that subsequent queries can automatically pull the next set of results without needing to pas the parameters again or specify a query start and limit. Pagination is automatic.
*/

import Foundation
import Parse

final class Data : NSObject {
    
    static let sharedInstance = Data()

    var radius : Int
    
    dynamic var success : Bool = false
    dynamic var meta_success : Bool = false
    dynamic var times_received : Int = 0
    dynamic var times_received_bookmarks : Int = 0
    dynamic var error : Bool = false
    dynamic var bookmarks_count : Int = 0
    var threadQueryLock : Bool = false
    var filterByTime = false
    
    var results : [Church] = []
    var bookmarks : [Church] = []
    
    var filterTypes : Dictionary<String, String> = ["denomination":"Denomination", "style":"Worship Style", "size":"Congregation Size"]
    var filterData : Dictionary<String, [AnyObject]> = [:]
    
    var currentParameters : Dictionary<String,AnyObject>
    var currentStart = 0
    var currentLimit = 0
    var currentLocation : PFGeoPoint
    
    /*
    Private init is used here so that a second instance cannot be created.
    */
    private override init() {
        radius = Constants.Defaults.Radius
        currentParameters = Constants.Defaults.get()
        currentLocation = Constants.Defaults.getLoc()
        
        super.init()
        
        pullBookmarks()
    }
    
    func churchFromObject(f: PFObject) -> Church {
        let church : Church = Church()
        
        church.id       = f.objectId!
        church.name     = f["name"]         as! String
        church.denom    = f["denomination"] as! String
        church.size     = f["size"]         as! Int
        church.style    = f["style"]        as! String
        church.location = f["loc"]          as! PFGeoPoint
        church.times    = f["times"]        as! String
        
        church.address      = f["address"]          as! String
        church.addr_street  = f["addr_street"]      as! String
        church.addr_city    = f["addr_city"]        as! String
        church.addr_state   = f["addr_state"]       as! String
        church.addr_zip     = f["addr_zip"]         as! String
        
        church.url      = f["url"]          as! String
        church.img      = f["banner"]       as? PFFile
        church.object   = f
     
        if f.objectForKey("description") != nil {
            church.desc    = f["description"]        as! String
        } else {
            church.desc    = ""
        }
        
        if f.objectForKey("phone") != nil {
            church.phone    = f["phone"]        as! String
        } else {
            church.phone    = ""
        }
        
        return church
    }
    
    /*
    Get list of possible values held by key.
    */
    func getMeta(let type : String) {
        
        let query = PFQuery(className: Constants.Parse.ChurchClass)
        
        query.whereKeyExists(type)
        query.selectKeys([type])
        query.orderByDescending(type)
        
        query.findObjectsInBackgroundWithBlock {
            (objects:[PFObject]?, error:NSError?) -> Void in
            
            data.meta_success = false
            
            if let found = objects {
                
                var options : [String] = []
                
                if(found.count == 0) {
                    
                    options.append("Any")
                    
                } else {
                    
                    options.append("Any")
                    for f in found {
                        
                        if(type == "size") {
                            
                            let meta = f[type] as! Int
                            
                            if(!options.contains(String(meta))) {
                                options.append(String(meta))
                            }
                            
                        } else {
                            
                            let meta = f[type] as! String
                            
                            if(!options.contains(meta)) {
                                options.append(meta)
                            }
                        }
                    }
                }
                
                print("Data: Meta search found \(options.count) results for \(type).")
                data.meta_success = true
                data.filterData[type] = options
                
            } else {
                if let e = error {
                    NSLog(e.description)
                } else {
                    NSLog("Data: There was an error but it was unreadable.")
                }
            }
        }
    }
    
    func getTimes(index : Int, forBookmarks : Bool = false) { // if results changes, cancel operation??
        
        if(threadQueryLock == true) {
            return
        }
        var id : String
        
        if forBookmarks {
            id = bookmarks[index].id
        } else {
            id = results[index].id
        }
        
        let query = PFQuery(className: "Service")
        query.whereKey("owner", containsString: id)
        
        query.findObjectsInBackgroundWithBlock {
            (objects:[PFObject]?, error:NSError?) -> Void in
            
            if let found = objects {
                
                var times : Array<Dictionary<String, Int>> = []
                
                if(found.count == 0) {
                    
                    print("Data: Times search found NO service times for \(id)")
                    
                } else {
                    
                    for f in found {
                        
                        let day = f["day"] as! String
                        let time = f["time"] as! Int
                        let service : Dictionary<String, Int> = [day:time]
                        times.append(service)
                        
                    }
                    
                    // because of threading, make sure that the result still exists before setting it's times
                    if forBookmarks {
                        
                        if(data.bookmarks[index].id == id && data.bookmarks[index].times_set.count == 0) {
                            print("Data: Times search found \(times.count) service times for bookmark \(id)")
                            data.bookmarks[index].times_set = times
                            data.times_received_bookmarks += 1
                        }
                        
                    } else {
                    
                        if(data.results[index].id == id && data.results[index].times_set.count == 0) {
                            print("Data: Times search found \(times.count) service times for \(id)")
                            data.results[index].times_set = times
                            data.times_received += 1
                        }
                    }
                }
                
            } else {
                if let e = error {
                    NSLog(e.description)
                } else {
                    NSLog("Data: There was an error but it was unreadable.")
                }
            }
        }
    }
    
    /*
    Update ChurchData.results with churches that match the requested parameters
    s and n are the start index and limit of the result we want to look at.
    
    TODO: take array of strings for times rathern than CSV
    TODO: find a way to show churches of a similar size once the closest results have been exhausted
    TODO: increase radius of search if results < limit, by 5 miles, up to 50
    */
    func pullResults(params : [String:AnyObject] = [:], let s : Int = 0, let n : Int = Constants.Defaults.NumberOfResultsToPullAtOnce) { //-> Bool {
        
        print("")
        print("Data: Pulling new results.")
        
        if(threadQueryLock == false) {
            threadQueryLock = true
        } else {
            return
        }
        
        if(params.count > 0) {
            print("Data: The following parameters were provided.")
            for p in params {
                print("     - \(p.0) as \(p.1)")
            }
            print("")
        } else {
            print("Data: No parameters were provided...")
        }
        
    // setup
        success = false
        error = false
        times_received = 0

        let query = PFQuery(className: Constants.Parse.ChurchClass)
        
    // no parameters passed in, prior query exists
        if(params.count == 0 && results.count > 0) {
            if(results.count == currentLimit) {                             // if we got a full set a results last time
                query.skip = currentStart + currentLimit                    // skip to the end of our last result set
                query.limit = currentLimit                                  // attempt to use the same limit as before
            } else if(results.count < currentLimit) {
                return                                                // if we clearly hit the limit last time, there are no more
            }
        }
            
    // no parameters passed in, no prior query
        else if(params.count == 0 && results.count == 0) {
            return
        }
            
    // parameters were passed in, results.count also == 0 here but it's implied
        else {
            clear()
            query.skip = s
            query.limit = n
        }
        
    
    // if individual parameters were requested apply them to query
        if let denom = params["denomination"] as? String {
            if(denom != "Any") {
                query.whereKey("denomination", containsString: denom)
            }
        }
        
        if let style = params["style"] as? String {
            if(style != "Any") {
                query.whereKey("style", containsString: style)
            }
        }
        
        if let size = params["size"] as? String {
            if(size != "Any") {
                if let s = Int(size) {
                    query.whereKey("size", greaterThan: s-150)
                    query.whereKey("size", lessThan: s+150)
                }
                //query.whereKey("size", equalTo: Int(size))
            }
        }
        
        if let loc = params["loc"] as? PFGeoPoint {
            currentLocation = loc
            query.whereKey("loc", nearGeoPoint:loc, withinMiles:100.0)
        } else {
            // if location wasn't set, use defaults set in constants
            query.whereKey("loc", nearGeoPoint: PFGeoPoint(latitude: currentLocation.longitude, longitude: currentLocation.latitude), withinMiles: 20.0)
        }
        
        
        query.findObjectsInBackgroundWithBlock {
            (objects:[PFObject]?, error:NSError?) -> Void in
            
            // check that we received results
            if let found = objects {
                
                // create results array
                data.results = []
                
                for f in found {
                    
                    let church : Church = data.churchFromObject(f)
                    church.object = f
                    data.results.append(church)
                    print("Data: Background search found '\(church.name)' in \(church.addr_city), \(church.addr_state)")
                }
                
                
                // future code...?
                
                //         compound query
                //         for(int i = 0; i < times.count; i++)
                //         if(time.count > 0) query.whereKey("time", containsString:...
                //
                //         after results are exhausted, get results in the subsequent radius
                //         so if results < number of results to get at once then try to increase radius by 1s up to 50
                //
                //         set results = query.results
                
                
                if(data.results.count > 0) {
                    print("Data: I found churches in the parse database.")
                    
                    if(params.count > 0) {
                        data.currentParameters = params
                    }
                    
                    data.currentStart = query.skip
                    data.currentLimit = query.limit
                    
                    data.threadQueryLock = false
                    data.success = true
    
                } else {
                    if(params.count > 0) {
                        data.currentParameters = Constants.Defaults.get()
                        data.currentParameters["loc"] = PFGeoPoint(latitude: data.currentLocation.latitude, longitude: data.currentLocation.longitude)
                    }
                    
                    print("Data: No results were found in the parse database or there was an error.")
                    data.error = true
                }
                
            } else {
                NSLog(error!.description)
                data.error = true
            }
            data.threadQueryLock = false
        }
    }
        
    func clear() {
        results = []
        currentParameters = [:]
        currentStart = 0
        currentLimit = 0
    }
    
    func addBookmark(addedChurch: Church) {
        for b in bookmarks {
            if (b.object!.objectId == addedChurch.object!.objectId) { return }
        }
        
        bookmarks.append(addedChurch)
        addedChurch.object!.pinInBackground()
        writeBookmarkOrder()
        print("Data: Added bookmark. \(bookmarks.count) total.")
        
        bookmarks_count = bookmarks.count
    }
    
    func removeBookmark(let bookmarkIndex : Int) {
        if (bookmarks.count > bookmarkIndex) {
            let remove = bookmarks[bookmarkIndex]
            remove.object!.unpinInBackground()
            bookmarks.removeAtIndex(bookmarkIndex)
            bookmarks_count = bookmarks.count
        }
        writeBookmarkOrder()
        //print("Data: Removed bookmark using int. \(bookmarks.count) remaining.")
    }
    
    func removeBookmark(bookmarkedChurch: Church) {
        for i in 0..<bookmarks.count {
            //print("Trying to remove index \(i) from \(bookmarks.count).")
            if(bookmarks[i].id == bookmarkedChurch.id) {
                bookmarks.removeAtIndex(i)
                //print("Data: Removed bookmark using church.id. \(bookmarks.count) remaining.")
                writeBookmarkOrder()
                bookmarks_count = bookmarks.count
                break
            }
        }
    }
    
    func pullBookmarks() {
        bookmarks = []
        let query = PFQuery(className: Constants.Parse.ChurchClass)
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                //Grab bookmark list file
                let path = (NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0] as NSString).stringByAppendingPathComponent("Bookmarks.list")
                var order : [String] = []
                if NSFileManager.defaultManager().fileExistsAtPath(path) {
                    var csv : String? = nil
                    do {
                        csv = try String(contentsOfFile: path)
                        order = csv!.componentsSeparatedByString(",")
                    } catch {
                        return
                    }
                }
                
                //Get Bookmarks
                var bookm : [Church] = []
                for f in objects! {
                    let church : Church = self.churchFromObject(f)
                    bookm.append(church)
                }
                
                //Set Order
                for s in order {
                    for b in bookm {
                        if s == b.id {
                            self.bookmarks.append(b)
                        }
                    }
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        bookmarks_count = bookmarks.count
    }
    
    func writeBookmarkOrder() {
        var csv : String = ""
        
        if(bookmarks.count > 0) {
            for b in bookmarks {
                csv.appendContentsOf(b.id + ",")
            }
            csv.removeAtIndex(csv.endIndex.predecessor())
        
            let path = (NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0] as NSString).stringByAppendingPathComponent("Bookmarks.list")
            
            do {
                try csv.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
            } catch {
                NSLog("File could not be written")
            }
        }
    }
    
    let pi = 3.14159265358979323846
    let earthRadiusKm = 6371.0
    let MIinKM = 0.62137119
    
    func deg2rad(deg: Double) -> Double {
        return (deg * pi / 180)
    }
    
    func rad2deg(rad: Double) -> Double {
        return (rad * 180 / pi)
    }
    
    // return the distance between two coordinates in km
    func calcuateDistance(lat1: Double, lng1: Double, lat2: Double, lng2: Double) -> Double {
        
        let lat1r = deg2rad(lat1)
        let lon1r = deg2rad(lng1)
        let lat2r = deg2rad(lat2)
        let lon2r = deg2rad(lng2)
        let u = sin((lat2r - lat1r)/2)
        let v = sin((lon2r - lon1r)/2)
        return 2.0 * earthRadiusKm * asin(sqrt(u * u + cos(lat1r) * cos(lat2r) * v * v))
    }
    
    func getDistance(loc : PFGeoPoint, church : Church) -> String {
        if loc != Constants.Defaults.getLoc() {
            var raw = calcuateDistance(church.location.latitude, lng1: church.location.longitude, lat2: loc.latitude, lng2: loc.longitude)
            raw *= MIinKM
            return String(format: "%0.1f", raw)
        } else {
            return "?"
        }
    }
    
    func restrictResultsByTime() {
        if let times = currentParameters["times"] as? Dictionary<String, AnyObject> {
            if let e = times["enabled"] as? Bool {
                if e == true {
                    print("praise the lord, lord of time")
                }
            }
        }
    }
    
    func formatTime(set: [String:Int]) -> String {
        var times : String = ""
        
        for (d,t) in set {
            let hr24 : Int = t/60
            let m : Int = t%60
            
            var m_formatted : String
            if(m == 0) {
                m_formatted = "00"
            } else {
                m_formatted = String(m)
            }
            
            var post = ""
            if(hr24 < 12) {
                post = "a"
            } else {
                post = "p"
            }
            
            var hr12 = hr24
            if(hr24 > 12) {
                hr12 -= 12
            }
            
            times += "\(d) \(hr12):\(m_formatted)\(post) "
        }
        
        return times
    }
}
    