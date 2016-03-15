//
//  TopBarViewController.swift
//  ChurchFinder
//
//  Created by Daniel Mitchell on 3/14/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//

import UIKit
import MapKit
import Parse

class TopBarViewController: UIViewController, CLLocationManagerDelegate, filterResultsDelegate, UISearchBarDelegate {
    
    var location : PFGeoPoint?
    var searchController:UISearchController!
    
    @IBOutlet weak var screenSwitcher: UISegmentedControl!
    @IBOutlet weak var listViewContainer: UIView!
    @IBOutlet weak var mapViewContainer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Start Location Services
        data.locationManager.delegate = self
        data.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        data.locationManager.requestWhenInUseAuthorization()
        data.locationManager.startUpdatingLocation()
        
        //Pull first data
        data.pullResults(Constants.Defaults.get())
        
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
        
        Data.sharedInstance.pullResults(Constants.Defaults.get())
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
    }
    
    func doneWithFilters(child: FilterTableViewController){
        data.currentParameters = params
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

    /*
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
    
    searchBar.resignFirstResponder()
    dismissViewControllerAnimated(true, completion: nil)
    if self.mapview.annotations.count != 0{
    annotation = self.mapview.annotations[0]
    self.mapview.removeAnnotation(annotation)
    }
    //take search request...
    localSearchRequest = MKLocalSearchRequest()
    localSearchRequest.naturalLanguageQuery = searchBar.text
    localSearch = MKLocalSearch(request: localSearchRequest)
    localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
    
    if localSearchResponse == nil{
    let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alertController, animated: true, completion: nil)
    return
    }
    //place a pin at the point
    self.pointAnnotation = MKPointAnnotation()
    self.pointAnnotation.title = searchBar.text
    self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
    
    self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
    //center map on searched location
    self.mapview.centerCoordinate = self.pointAnnotation.coordinate
    self.mapview.addAnnotation(self.pinAnnotationView.annotation!)
    self.mapview.setRegion(MKCoordinateRegion(center: localSearchResponse!.boundingRegion.center, span: MKCoordinateSpan(latitudeDelta:1,longitudeDelta: 1)),animated:true)
    
    }
    }
    */
}
