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

class MapViewController: UIViewController, MKMapViewDelegate, detailedViewDelegate {
    
    var current = Church()
    
    var annotation: MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var parCheck: Int!
    var churchAn: [churchAnnotation]!
    
    @IBOutlet weak var mapview: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parCheck = 10
        self.mapview.showsUserLocation = true
        mapview.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
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
        
        mapview.showAnnotations(mapview.annotations, animated: true)
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "mapToDetSeg") {
            let dest = segue.destinationViewController as! DetailedViewController
            dest.delegate = self
            dest.church = current
        }
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
