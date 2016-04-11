/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Dan Mitchell
Created: 03/14/16
*/

import UIKit
import MapKit
import Parse

class TopBarViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {
    
    var location : PFGeoPoint?
    var searchController:UISearchController!
    
    @IBOutlet weak var screenSwitcher: UISegmentedControl!
    @IBOutlet weak var listViewContainer: UIView!
    @IBOutlet weak var mapViewContainer: UIView!
    
    var mapViewController: MapViewController!
    var listViewController: ListViewController!
    
    let manager = CLLocationManager()
    var p = Constants.Defaults.get()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Request user location
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        //manager.requestLocation()
        
        data.pullResults(p)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Location services
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        if let location = locations.first {
            NSLog("Found user's location: \(location)")
            
            p["loc"] = PFGeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            print(p)
            //data.pullResults(p)
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("Failed to find user's location: \(error.localizedDescription)")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "filterViewSegue") {
            let child = segue.destinationViewController as! FiltersViewController
            //child.delegate = self
            
        }
        else if(segue.identifier == "mapViewSegue"){
            mapViewController = segue.destinationViewController as! MapViewController
        }
        else if(segue.identifier == "listViewSegue"){
            listViewController = segue.destinationViewController as! ListViewController
            
        }
    }
    
    @IBAction func doneWithFilters(segue: UIStoryboardSegue){
        //data.pullResults(params)
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func switchScreens(sender: AnyObject) {
        if screenSwitcher.selectedSegmentIndex == 0 {
            UIView.animateWithDuration(0.5, animations: {
                self.listViewContainer.alpha = 1
                self.mapViewContainer.alpha = 0
            })
        } else {
            UIView.animateWithDuration(0.5, animations: {
                self.listViewContainer.alpha = 0
                self.mapViewContainer.alpha = 1
            })
        }
    }
    
    // MARK: - Search Bar
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func showSearchBar(sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)
        
    }
}
