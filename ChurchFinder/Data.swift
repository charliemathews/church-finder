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
    var results : [Church] = []
    var bookmarks : [Church] = []
    
    var filterTypes : Dictionary<String, String> = ["denomination":"Denomination", "style":"Worship Style", "size":"Congregation Size"]
    var filterData : Dictionary<String, [AnyObject]> = [:]
    
    var currentParameters : Dictionary<String,AnyObject>
    var currentStart = 0
    var currentLimit = 0
    
    /*
    Private init is used here so that a second instance cannot be created.
    */
    private override init() {
        radius = Constants.Defaults.Radius
        currentParameters = Constants.Defaults.get()
        
        super.init()
        
        pullBookmarks()
        
        NSOperationQueue.mainQueue().addOperationWithBlock({
            for (type, _) in self.filterTypes {
                print(type)
                self.filterData[type] = self.getMeta(type)
            }
        })
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
        church.address  = f["address"]      as! String
        church.desc     = f["description"]  as! String
        church.url      = f["url"]          as! String
        church.img      = f["banner"]       as? PFFile
        church.object   = f
     
        return church
    }
    
    /*
    Get list of possible values held by key.
    */
    func getMeta(let type : String) -> [String] {
        
        var options : [String] = []
        let query = PFQuery(className: Constants.Parse.ChurchClass)
        
        query.whereKeyExists(type)
        query.selectKeys([type]) // alternative to checking each input to see if it's valid
        query.orderByDescending(type)
        
        var found : [PFObject] = []
        
        do {
            try found = query.findObjects()
        }
        catch {
            options.append("No meta data found.")
            return options // alternative to checking each input to see if it's valid
        }
        
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
        
        return options
    }
    
    /*
    Update ChurchData.results with churches that match the requested parameters
    s and n are the start index and limit of the result we want to look at.
    
    TODO: take array of strings for times rathern than CSV
    TODO: find a way to show churches of a similar size once the closest results have been exhausted
    TODO: increase radius of search if results < limit, by 5 miles, up to 50
    */
    func pullResults(params : [String:AnyObject] = [:], let s : Int = 0, let n : Int = Constants.Defaults.NumberOfResultsToPullAtOnce) { //-> Bool {
        
        NSLog("Pulling new results.")
        print(params)
        
    // setup
        success = false
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
                query.whereKey("size", equalTo: String(size))
            }
        }
        
        if let loc = params["loc"] as? PFGeoPoint {
            query.whereKey("loc", nearGeoPoint:loc, withinMiles:100.0)
        } else {
            // if location wasn't set, use defaults set in constants
            query.whereKey("loc", nearGeoPoint: PFGeoPoint(latitude: Constants.Defaults.Lat, longitude: Constants.Defaults.Lon), withinMiles: 20.0)
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
                    print("Background search found '\(church.name)'")
                }
                
                //         compound query
                //         for(int i = 0; i < times.count; i++)
                //         if(time.count > 0) query.whereKey("time", containsString:...
                //
                //         after results are exhausted, get results in the subsequent radius
                //         so if results < number of results to get at once then try to increase radius by 1s up to 50
                //
                //         set results = query.results
                
                if(data.results.count > 0) {
                    NSLog("We found churches in the parse database.")
                    
                    data.success = true
                    
                    if(params.count > 0) {
                        data.currentParameters = params
                    }
                    
                    data.currentStart = query.skip
                    data.currentLimit = query.limit
                    
                    //return true
                    
                } else {
                    NSLog("No results were found in the parse database or there was an error.")
                    //return false
                }
                
            } else {
                print(error?.description)
            }
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
    }
    
    func removeBookmark(let bookmarkIndex : Int) {
        if (bookmarks.count > bookmarkIndex) {
            let remove = bookmarks[bookmarkIndex]
            remove.object!.unpinInBackground()
            bookmarks.removeAtIndex(bookmarkIndex)
        }
        writeBookmarkOrder()
    }
    
    func removeBookmark(bookmarkedChurch: Church) {
        //find the index
        var index = 0
        for church in bookmarks {
            if (church.id == bookmarkedChurch.id){
                break
            } else {
                index += 1
            }
        }
        
        if (index < bookmarks.count) {
            removeBookmark(index)
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
    }
    
    func writeBookmarkOrder() {
        var csv : String = ""
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
    