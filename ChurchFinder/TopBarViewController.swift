/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Dan Mitchell
Created: 03/14/16
*/

import UIKit
import MapKit
import Parse

class TopBarViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {
    //var isCustomSearch: Bool = false
    
    
    var location : PFGeoPoint?
    var searchController:UISearchController!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    @IBOutlet weak var screenSwitcher: UISegmentedControl!
    @IBOutlet weak var listViewContainer: UIView!
    @IBOutlet weak var mapViewContainer: UIView!
    @IBOutlet weak var filtersButton: UIBarButtonItem!
    
    var mapViewController: MapViewController!
    var listViewController: ListViewController!
    
    let manager = CLLocationManager()
    var p = Constants.Defaults.get()
    
    var indicator = UIActivityIndicatorView()
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        indicator.center = self.view.center
        //indicator.center.y -= 100
        self.view.addSubview(indicator)
    }
    
    func setTint(view: UIImageView, tint: UIColor) {
        let i = view.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        view.image = i
        view.tintColor = tint
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show loading indicator on first load
        activityIndicator()
        indicator.startAnimating()
        
        // disable filters button until location has been identified and first pull is successful
        filtersButton.enabled = false
        loadObservers()
        
        // request user location
        print("TopBar: Requesting user's location.")
        manager.requestWhenInUseAuthorization()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.distanceFilter = 500
        manager.requestLocation()
        
        // pull meta
        NSOperationQueue.mainQueue().addOperationWithBlock({
            for (type, _) in data.filterTypes {
                data.getMeta(type)
            }
        })
        
        /*
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .ScaleAspectFill
        let image = UIImage(named: "location_icon.png")
        imageView.image = image
        setTint(imageView, tint: UIColor.blueColor())
        searchButton.customView!.addSubview(imageView)
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadObservers() {
        data.addObserver(self, forKeyPath: "success", options: Constants.KVO_Options, context: nil)
        data.addObserver(self, forKeyPath: "error", options: Constants.KVO_Options, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        //print("TopBar: I sense that value of \(keyPath) changed to \(change![NSKeyValueChangeNewKey]!)")
        
        if(keyPath == "success") {
            if(data.success == false) {
                
                filtersButton.enabled = false
                indicator.startAnimating()
                indicator.backgroundColor = UIColor.whiteColor()
                
            } else {
                
                print("TopBar: I see \(data.results.count) church results.")
                
                for i in 0..<data.results.count {
                    if(data.threadQueryLock == true) { // if another query is running, we should be waiting for that query.
                        return
                    }
                    data.getTimes(i)
                }
                
                data.restrictResultsByTime()
                
                filtersButton.enabled = true
                indicator.stopAnimating()
                indicator.hidesWhenStopped = true
                
                if(data.results.count == 0) {
                    let alert = UIAlertController(title: "Whoops!", message: "Sorry, we couldn't find any churches with those criteria. We'll show you the results of last successful search.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
            }
        } else if(keyPath == "error" && data.error == true) {
            filtersButton.enabled = true
            indicator.stopAnimating()
            indicator.hidesWhenStopped = true
            
            //if(self.isViewLoaded() == true) {
                let alert = UIAlertController(title: "Whoops!", message: "Sorry, we couldn't find any churches with those criteria. We'll show you the results of last successful search.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            //}
        }
        
    }
    
    deinit {
        data.removeObserver(self, forKeyPath: "success", context: nil)
        data.removeObserver(self, forKeyPath: "error", context: nil)
    }
    
    //MARK: Location services
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //print("TopBar: User's location updated.")
        
        if let location = locations.first {
            
            print("TopBar: Found user's location: \(location)")
            
            p["loc"] = PFGeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            data.pullResults(p)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("TopBar: Failed to find user's location: \(error.localizedDescription)")
        
        data.pullResults(p)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if(segue.identifier == "filterViewSegue") {
            
            //let child = segue.destinationViewController as! FiltersViewController
            //child.delegate = self
            
        } else if(segue.identifier == "mapViewSegue"){
            
            mapViewController = segue.destinationViewController as! MapViewController
            
        } else if(segue.identifier == "listViewSegue"){
            
            listViewController = segue.destinationViewController as! ListViewController
        }
    }
    
    @IBAction func doneWithFilters(segue: UIStoryboardSegue){
        print("Unwound from filters and requested new results.")
        let sender = segue.sourceViewController as! FiltersViewController
        let params = sender.filterSelected
        data.pullResults(params)
    }
    
    @IBAction func switchScreens(sender: AnyObject) {
        if screenSwitcher.selectedSegmentIndex == 0 {
            UIView.animateWithDuration(0.5, animations: {
                self.listViewContainer.alpha = 1
                self.mapViewContainer.alpha = 0
            })
        } else {
            self.mapViewController.outputChurchResultsToMap()
            UIView.animateWithDuration(0.5, animations: {
                self.listViewContainer.alpha = 0
                self.mapViewContainer.alpha = 1
            })
        }
    }
    
    @IBAction func unwindFromDetailedToSearch(segue: UIStoryboardSegue){
        print("Unwound from detailed to search.")
        
    }
    
    // MARK: - Search Bar
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        
        localSearch.startWithCompletionHandler{(localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            
            let lat = localSearchResponse?.boundingRegion.center.latitude
            let lon = localSearchResponse?.boundingRegion.center.longitude
            
            var newParams = data.currentParameters
            newParams["loc"] = PFGeoPoint(latitude: lat!, longitude: lon!)
            data.pullResults(newParams)
        }
    }
    
    @IBAction func showSearchBar(sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search by address, city, or zip..."
        presentViewController(searchController, animated: true, completion: nil)
        
    }
}
