/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Charlie Mathews
Created: 21/02/16
Modified: 25/02/16

Changelog
* 25-02-16 Merged into master.
* 25-02-16 After a successful call to pullResults, subsequent calls will attempt to pull the next page of results automatically.

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

final class Data {
    
    static let sharedInstance = Data()
    
    let defaultRadius = 20
    var radius : Int
    
    var results : [Church] = []
    var bookmarks : [Church] = []
    
    let locationManager = CLLocationManager()
    
    var currentParameters : [String:AnyObject] = [:]
    var currentStart = 0
    var currentLimit = 0
    
    /*
    Private init is used here so that a second instance cannot be created.
    */
    private init() {
        radius = defaultRadius
        pullBookmarks()
    }
    
    /*
    Get list of possible values held by key.
    */
    func getMeta(let type : String) -> [String] {
        
        var options : [String] = []
        let query = PFQuery(className: Constants.Parse.ChurchClass)
        
        query.whereKeyExists(type)
        query.selectKeys([type]) // alternative to checking each input to see if it's valid
        
        var found : [PFObject] = []
        
        do {
            try found = query.findObjects()
        }
        catch {
            options.append("No results.")
            return options // alternative to checking each input to see if it's valid
        }
        
        for f in found {
            if(!options.contains(f[type] as! String)) {
                options.append(f[type] as! String)
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
    func pullResults(var params : [String:AnyObject] = [:], let s : Int = 0, let n : Int = Constants.Defaults.NumberOfResultsToPullAtOnce) -> Bool {
        
        let query = PFQuery(className: Constants.Parse.ChurchClass)
        
        
        // no parameters passed in, prior query exists
        if(params.count == 0 && results.count > 0) {
            if(results.count == currentLimit) {                             // if we got a full set a results last time
                query.skip = currentStart + currentLimit                    // skip to the end of our last result set
                query.limit = currentLimit                                  // attempt to use the same limit as before
            } else if(results.count < currentLimit) {
                return false                                                // if we clearly hit the limit last time, there are no more
            }
        }
            
            // no parameters passed in, no prior query
        else if(params.count == 0 && results.count == 0) {
            return false
        }
            
            // parameters were passed in, results.count also == 0 here but it's implied
        else {
            query.skip = s
            query.limit = n
        }
        
        
        // if individual parameters were requested apply them to query
        if let denom = params["denomination"] as? String {
            query.whereKey("denomination", containsString: denom)
        }
        
        if let style = params["style"] as? String {
            query.whereKey("style", containsString: style)
        }
        
        if let size = params["size"] as? Int {
            query.whereKey("size", equalTo: size)
        }
        
        if let loc = params["loc"] as? PFGeoPoint {
            query.whereKey("loc", nearGeoPoint:loc, withinMiles:100.0)
        } else {
            // if location wasn't set, use defaults set in constants
            query.whereKey("loc", nearGeoPoint: PFGeoPoint(latitude: Constants.Defaults.Lat, longitude: Constants.Defaults.Lon), withinMiles: 20.0)
        }
        
        
        var found : [PFObject]
        
        do {
            try found = query.findObjects()
        }
        catch {
            return false
        }
        
        results = []
        
        for f in found {
            let church : Church = Church()
            
            church.name     = f["name"]         as! String
            church.denom    = f["denomination"] as! String
            church.size     = f["size"]         as! Int
            church.style    = f["style"]        as! String
            church.location = f["loc"]          as! PFGeoPoint
            church.times    = f["times"]        as! String
            church.address  = f["address"]      as! String
            church.desc     = f["description"]  as! String
            church.url      = f["url"]          as! String
            church.object   = f                              // <--   !!!!!! WHY. BAD. MUST REMOVE !!!!!!
            
            results.append(church)
        }
        
        // compound query
        // for(int i = 0; i < times.count; i++)
        // if(time.count > 0) query.whereKey("time", containsString:...
        
        // after results are exhausted, get results in the subsequent radius
        // so if results < number of results to get at once then try to increase radius by 1s up to 50
        
        // set results = query.results
        
        if(results.count > 0) {
            if(params.count > 0) {
                self.currentParameters = params
            }
            currentStart = query.skip
            currentLimit = query.limit
            return true
        } else {
            return false
        }
    }
    
    func clear() {
        results = []
        currentParameters = [:]
        currentStart = 0
        currentLimit = 0
    }
    
    func addBookmark(let resultIndex : Int) {
        if (results.count > resultIndex) {
            
            let addition = results[resultIndex]
            
            for b in bookmarks {
                if (b.object!.objectId == addition.object!.objectId) { return }
            }
            
            bookmarks.append(addition)
            addition.object!.pinInBackground()
        }
    }
    
    func addBookmark(addedChurch: Church) {
        //find the index
        var index = 0
        for church in results {
            if (church.id == addedChurch.id){
                break
            } else {
                index++
            }
        }
        
        if (index < results.count) {
            addBookmark(index)
        }
    }
    
    func removeBookmark(let bookmarkIndex : Int) {
        if (bookmarks.count > bookmarkIndex) {
            let remove = bookmarks[bookmarkIndex]
            remove.object!.unpinInBackground()
            bookmarks.removeAtIndex(bookmarkIndex)
        }
    }
    
    //for detailed view
    func removeBookmark(bookmarkedChurch: Church) {
        //find the index
        var index = 0
        for church in bookmarks {
            if (church.id == bookmarkedChurch.id){
                break
            } else {
                index++
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
                
                for f in objects! {
                    let church : Church = Church()
                    
                    church.name     = f["name"]         as! String
                    church.denom    = f["denomination"] as! String
                    church.size     = f["size"]         as! Int
                    church.style    = f["style"]        as! String
                    church.location = f["loc"]          as! PFGeoPoint
                    church.times    = f["times"]        as! String
                    church.address  = f["address"]      as! String
                    church.desc     = f["description"]  as! String
                    church.url      = f["url"]          as! String
                    church.object   = f
                    
                    self.bookmarks.append(church)
                }
                
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
}
    