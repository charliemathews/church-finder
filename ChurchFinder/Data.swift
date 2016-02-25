/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Charlie Mathews
Created: 21/02/16
Modified: 24/02/16

Changelog
* Magnificent file header was authored by codereview2k16 #squad

Tested & Passed
Unit:               {mm/dd/yy} by {last name}
Integration:        {mm/dd/yy} by {last name}

Sources:
http://krakendev.io/blog/the-right-way-to-write-a-singleton
https://parse.com/questions/retrieving-unique-values
*/

import Foundation
import Parse

final class Data {
    
    static let sharedInstance = Data()
    
    var results : [Church] = []
    var params : [String:AnyObject] = [:]
    
    // to remove, use params
    var current_denom : String = ""
    var current_style : String = ""
    var current_size : Int = 0
    var current_time : String = ""
    var current_loc : PFGeoPoint = PFGeoPoint()
    
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
    */
    func pullResults(let s : Int = 0, let n : Int = 10, let params : [String:AnyObject] = [:]) {
        //REMOVED let loc : PFGeoPoint = PFGeoPoint(),
        
        // if params is empty, the person pulling results must want the next set of results
        
        let query = PFQuery(className: Constants.Parse.ChurchClass)
        query.skip = s
        
        if let denom = params["denomination"] as? String {
            query.whereKey("denomination", containsString: denom)
        }
        if let style = params["style"] as? String {
            query.whereKey("style", containsString: style)
        }
        if let size = params["size"] as? Int {
            query.whereKey("size", equalTo: size)
        }
        
        // if location is blank, set it to grove city pa
        
        // compound query
        // for(int i = 0; i < times.count; i++)
        // if(time.count > 0) query.whereKey("time", containsString:...
        
        // after results are exhausted, get results in the subsequent radius
        
        self.params = params // only save params once results are successfully pulled
        //return results
    }
    
}
    