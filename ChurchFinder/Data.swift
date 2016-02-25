/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Charlie Mathews
Created: 21/02/16
Modified: 25/02/16

Changelog
* 25-02-16 Merged into master.

Tested & Passed
Unit:               {mm/dd/yy} by {last name}
Integration:        {mm/dd/yy} by {last name}

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
    var currentResultParameters : [String:AnyObject] = [:]
    
    /*
    Private init is used here so that a second instance cannot be created. This function acts as an initial search function, filling the results with information from the default search parameters.
    */
    private init() {
        pullResults(0, n: 10, params: Constants.Defaults.get())
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
    func pullResults(let s : Int = 0, let n : Int = 10, let params : [String:AnyObject] = [:]) {
        
        // TODO
        // if params is empty, the person pulling results must want the next set of results
        // use params which was stored if it is not empty
        
        let query = PFQuery(className: Constants.Parse.ChurchClass)
        query.skip = s
        query.limit = n
        
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
        
        // compound query
        // for(int i = 0; i < times.count; i++)
        // if(time.count > 0) query.whereKey("time", containsString:...
        
        // after results are exhausted, get results in the subsequent radius
        
        self.currentResultParameters = params // only save params once results are successfully pulled
        //return results
    }
    
}
    