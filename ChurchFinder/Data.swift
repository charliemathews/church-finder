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
    
    var results : [Church] = []
    var currentParameters : [String:AnyObject] = [:]
    var currentStart = 0
    var currentLimit = 0
    
    /*
    Private init is used here so that a second instance cannot be created. This function acts as an initial search function, filling the results with information from the default search parameters.
    */
    private init() {
        pullResults(Constants.Defaults.get())
    }
    
    /*
    Returns a list of options for denominations, church sizes, and worship sytles
    */
    func getMeta(let type : String) -> [String] {
        
        var options : [String] = []
        let query = PFQuery(className: Constants.Parse.ChurchClass)
        
        /* TO BE DELETED AFTER DEBUGGING
        // use query.wherekeyexists instead?
        if(type != "denomination" && type != "size" && type != "style") {
        return options
        }
        */
        
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
            options.append(f[type] as! String)
        }
        
        return options
    }
    
    /*
    Update ChurchData.results with churches that match the requested parameters
    s and n are the start index and limit of the result we want to look at.
    
    TODO: take array of strings for times rathern than CSV
    TODO: find a way to show churches of a similar size once the closest results have been exhausted
    TODO: automatic pagination
    TODO: if params is empty, pull next set. see below.
    */
    func pullResults(var params : [String:AnyObject] = [:], let s : Int = 0, let n : Int = Constants.Defaults.NumberOfResultsToPullAtOnce) -> Bool {
        
        let query = PFQuery(className: Constants.Parse.ChurchClass)
        
        
        // if no parameters were passed in, the user probbaly wants the next set of results in the table
        if(params.count == 0 && results.count > 0) {
            if(results.count == currentLimit) {                             // if we got a full set a results last time
                query.skip = currentStart + currentLimit                    // skip to the end of our last result set
                query.limit = currentLimit                                  // attempt to use the same limit as before
            } else if(results.count < currentLimit) {
                return false                                                // if we clearly hit the limit last time, there are no more
            }
        }
            
        // parameters were passed in, skip to the requested result and use requested limit
        else {
            params = Constants.Defaults.get()
            query.skip = s
            query.limit = n
        }
        
        
        // if parameters were requested apply them to query
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
        
        for f in found {
            let church : Church = Church()
            church.name = f["name"] as! String
            results.append(church)
        }
        
        // compound query
        // for(int i = 0; i < times.count; i++)
        // if(time.count > 0) query.whereKey("time", containsString:...
        
        // after results are exhausted, get results in the subsequent radius
        // so if results < number of results to get at once then try to increase radius by 1s up to 50
        
        // set results = query.results
        
        if(params.count > 0) {             // if results were successfully pulled and we didn't use stored parameters
            self.currentParameters = params
        }
        if(results.count > 0) {
            currentStart = query.skip
            currentLimit = query.limit
            return true
        } else {
            return false
        }
    }
    
}
    