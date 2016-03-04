/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Sarah Burgess
Created:
Modified: 24/02/16

Changelog
...

Sources
...
*/

import UIKit
import MapKit

protocol mapViewControllerDelegate{
    func doneWithMapView(child: MapViewController)
}

class MapViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate, UISearchBarDelegate, filterResultsDelegate{
    
    @IBOutlet weak var listMapSwitchControl: UISegmentedControl!
    @IBOutlet weak var mapView: MapViewController!
    @IBOutlet weak var listView: ListViewController!
    
    @IBOutlet var listMapSegControl: UISegmentedControl!
    
    var delegate: mapViewControllerDelegate!
    var searchController:UISearchController!
    var annotation: MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var parCheck: Int!
    
    @IBOutlet weak var filBut: UIBarButtonItem!
    //@IBOutlet weak var mapSearch: UISearchBar!
    @IBOutlet weak var mapview: MKMapView!
    
    @IBAction func showSearchBar(sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)
        
    }
    
    @IBAction func doneWithMap(sender: AnyObject) {
        delegate.doneWithMapView(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        parCheck = 10
        Data.sharedInstance.locationManager.delegate = self
        Data.sharedInstance.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        Data.sharedInstance.locationManager.requestWhenInUseAuthorization()
        Data.sharedInstance.locationManager.startUpdatingLocation()
        self.mapview.showsUserLocation = true
        listMapSegControl.selectedSegmentIndex = 1
       
        
    }
    
    @IBAction func listMapSwitched(sender: AnyObject) {
        if(listMapSwitchControl.selectedSegmentIndex == 0)
        {
    
        }else
        {
        
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func locationManager(manager:CLLocationManager,didUpdateLocations locations: [CLLocation]){
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center:center, span: MKCoordinateSpan(latitudeDelta:1,longitudeDelta: 1))
        self.mapview.setRegion(region, animated: true)
        manager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print("Errors: " + error.localizedDescription)
    }
    
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        //1
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        if self.mapview.annotations.count != 0{
            annotation = self.mapview.annotations[0]
            self.mapview.removeAnnotation(annotation)
        }
        //2
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
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapview.centerCoordinate = self.pointAnnotation.coordinate
            self.mapview.addAnnotation(self.pinAnnotationView.annotation!)
            self.mapview.setRegion(MKCoordinateRegion(center: localSearchResponse!.boundingRegion.center, span: MKCoordinateSpan(latitudeDelta:1,longitudeDelta: 1)),animated:true)

        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let child = segue.destinationViewController as! FilterTableViewController
        child.delegate = self
    }
    func doneWithFilters(child: FilterTableViewController){
        dismissViewControllerAnimated(true, completion: nil)
    }
}

