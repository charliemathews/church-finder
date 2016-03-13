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

class MapViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate, UISearchBarDelegate, filterResultsDelegate, detailedViewDelegate{
    
    @IBOutlet weak var listMapSwitchControl: UISegmentedControl!
    @IBOutlet weak var mapView: MapViewController!
    @IBOutlet weak var listView: ListViewController!
    
    @IBOutlet var listMapSegControl: UISegmentedControl!
    
    var current = Church()
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
    var churchAn: [churchAnnotation]!
    
    @IBOutlet weak var filBut: UIBarButtonItem!
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
        //first time map loads, it pulls on the users current location
        data.locationManager.delegate = self
        data.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        data.locationManager.requestWhenInUseAuthorization()
        data.locationManager.startUpdatingLocation()
        self.mapview.showsUserLocation = true
        listMapSegControl.selectedSegmentIndex = 1
        mapview.delegate = self
        outputChurchResultsToMap()
    }
    
    func outputChurchResultsToMap() -> Bool {
        if(data.results.count == 0) {
            NSLog("no results?")
            return false
        }
        let anotView = MKAnnotationView()
        let detailBut = UIButton(type: .DetailDisclosure)
        anotView.rightCalloutAccessoryView = detailBut
        for r in data.results {
            let lat = r.location.latitude
            let lon = r.location.longitude
        
            let loc = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            //let pin = MKPointAnnotation()
            let pin = churchAnnotation(title: r.name, times: r.times, church: r, coordinate: loc)
            
            mapview.addAnnotation(pin)
        }
        
        //let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        //let reg = MKCoordinateRegion(center: loc, span: span)
        //map.setRegion(reg, animated: false)
        
        mapview.showAnnotations(mapview.annotations, animated: true)
        return true
    }
    
    //I really don't think this is relevant anymore
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
    
    
    //center map on current location
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "mapToDetSegue") {
            let dest = segue.destinationViewController as! DetailedViewController
            dest.delegate = self
            dest.church = current
        }
        else if(segue.identifier == "mapToFiltersSegue") {
            let child = segue.destinationViewController as! FilterTableViewController
            child.delegate = self
        }
    }
    func doneWithFilters(child: FilterTableViewController){
        data.currentParameters = params
        dismissViewControllerAnimated(true, completion: nil)
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var view = MKPinAnnotationView()
        //check if user location
        if(annotation.isKindOfClass(MKUserLocation)) {
            return nil
        }
        //try to dismiss already open
        if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation:annotation,reuseIdentifier:"pin")
            view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            view.canShowCallout = true
        }
        return view
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //I don't know how to convert this if condition to swift 1.2 but you can remove it since you don't have any other button in the annotation view
        
        let ch = view.annotation as! churchAnnotation
        current = ch.church
        
        if (control as? UIButton)?.buttonType == UIButtonType.DetailDisclosure {
            mapView.deselectAnnotation(view.annotation, animated: false)
            performSegueWithIdentifier("mapToDetSeg", sender: view)
        }
    }
    
    func done(child: DetailedViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

