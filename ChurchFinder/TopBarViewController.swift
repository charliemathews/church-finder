/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Dan Mitchell
Created: 03/14/16
*/

import UIKit
import MapKit
import Parse

class TopBarViewController: UIViewController, CLLocationManagerDelegate, filterResultsDelegate, UISearchBarDelegate {
    
    var location : PFGeoPoint?
    var searchController:UISearchController!
    
    @IBOutlet weak var screenSwitcher: UISegmentedControl!
    @IBOutlet weak var listViewContainer: UIView!
    @IBOutlet weak var mapViewContainer: UIView!
    
    var mapViewController: MapViewController!
    var listViewController: ListViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Start Location Services
        data.locationManager.delegate = self
        data.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        data.locationManager.requestWhenInUseAuthorization()
        data.locationManager.startUpdatingLocation()
        
        data.pullResults(Constants.Defaults.get(), sender: self)
        
        //Initialize params variable
        params["denoms"] = ""
        params["style"] = ""
        params["size"] = ""
        params["times"] = ""
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Location services
    
    func locationManager(manager:CLLocationManager,didUpdateLocations locations: [CLLocation]) {
        location = PFGeoPoint(location: locations.last)
        manager.stopUpdatingLocation()
        
        //Data.sharedInstance.pullResults(Constants.Defaults.get(), sender: self)
        //table.reloadData()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print("Errors: " + error.localizedDescription)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "filterViewSegue") {
            let child = segue.destinationViewController as! FilterTableViewController
            child.delegate = self
        }
        else if(segue.identifier == "mapViewSegue"){
            mapViewController = segue.destinationViewController as! MapViewController
        }
        else if(segue.identifier == "listViewSegue"){
            listViewController = segue.destinationViewController as! ListViewController
            
        }
    }
    
    func doneWithFilters(child: FilterTableViewController){
        data.pullResults(params, sender: self)
        dismissViewControllerAnimated(true, completion: nil)
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
