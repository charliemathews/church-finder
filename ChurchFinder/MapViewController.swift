/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Sarah Burgess
*/

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var current = Church()
    
    var annotation: MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var churchAn: [churchAnnotation]!
    
    @IBOutlet weak var mapview: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapview.showsUserLocation = true
        mapview.delegate = self
        loadObservers()
    }
    
    override func viewDidAppear(animated: Bool) {
        outputChurchResultsToMap()
    }
    
    func loadObservers() {
        data.addObserver(self, forKeyPath: "times_received", options: Constants.KVO_Options, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if(keyPath == "times_received" && data.times_received == data.results.count && data.threadQueryLock == false) {
            
            outputChurchResultsToMap()
        }
        
    }
    
    deinit {
        data.removeObserver(self, forKeyPath: "times_received", context: nil)
    }
    
    func outputChurchResultsToMap() -> Bool {
        if(data.results.count == 0) {
            return false
        }
        
        //remove old annotations
        mapview.removeAnnotations(mapview.annotations)
        
        let anotView = MKAnnotationView()
        let detailBut = UIButton(type: .DetailDisclosure)
        anotView.rightCalloutAccessoryView = detailBut
        
        //add churches to map
        for r in data.results {
            let lat = r.location.latitude
            let lon = r.location.longitude
            let loc = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            
            var t : String = ""
            
            if(r.times_set.count == 0) {
                
                t = "No service times listed."
                
            } else {
                
                var times : String = ""
                let sets = r.times_set
                
                for set in sets {
                    for (d,t) in set {
                        let h : Int = t/60
                        let m : Int = t%60
                        
                        var m_formatted : String
                        if(m == 0) {
                            m_formatted = "00"
                        } else {
                            m_formatted = String(m)
                        }
                        
                        times += "\(d) \(h):\(m_formatted) "
                    }
                }
                
                t = times
            }
            
            let pin = churchAnnotation(title: r.name, times: t, church: r, coordinate: loc)
            
            mapview.addAnnotation(pin)
        }
        
        //scale map to show pins
        mapview.showAnnotations(mapview.annotations, animated: true)
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "mapToDetailed") {
            let dest = segue.destinationViewController as! DetailedViewController
            dest.church = current
            dest.creator = "map"
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
            performSegueWithIdentifier("mapToDetailed", sender: view)
        }
    }
    
    func done(child: DetailedViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
