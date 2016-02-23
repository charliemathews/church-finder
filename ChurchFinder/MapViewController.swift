/*
    Copyright 2016 Serious Llama and Grove City College. All rights reserved.
    
    Author: Sarah Burgess
    Created: Great question.
    Modified: Recently.
    
    Changelog
        * Magnificent file header was authored by codereview2k16 #squad

    Tested & Passed
        Unit:               {mm/dd/yy} by {last name}
        Integration:        {mm/dd/yy} by {last name}
*/

import UIKit
import MapKit
class MapViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate, UISearchBarDelegate, filterResultsDelegate{
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parCheck = 10
        Globals.sharedInstance.locationManager.delegate = self
        Globals.sharedInstance.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        Globals.sharedInstance.locationManager.requestWhenInUseAuthorization()
        Globals.sharedInstance.locationManager.startUpdatingLocation()
        self.mapview.showsUserLocation = true
        
        
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
    func done(child: FilterTableViewController){
        parCheck = child.check
        dismissViewControllerAnimated(true, completion: nil)
    }
}

