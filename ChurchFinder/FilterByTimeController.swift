//
//  FilterByTimeController.swift
//  ChurchFinder
//
//  Created by Charles Mathews on 4/17/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//

import UIKit

class FilterByTimeController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var picker: UIPickerView!
    
    //var pickerDataSource : [Int] = []
    
    var days : [String] = []
    var hours : [Int] = []
    var mins : [Int] = []
    let period : [String] = ["AM", "PM"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var smallest_hour : Int = 0
        var greatest_hour : Int = 0
        
        if(data.allTimes.count > 0) {
            
            var hour : Int = data.allTimes[0].time/60
            if(hour > 12) {
                hour -= 12
            }
            smallest_hour = hour
            greatest_hour = hour
        
        
            for t in data.allTimes { // fill days array and find smallest/greatest hour
                
                if !days.contains(t.day) {
                    days.append(t.day)
                }
                
                var h : Int = t.time/60
                if(h > 12) {
                    h -= 12
                }
                
                if(h < smallest_hour) {
                    smallest_hour = h
                } else if(h > greatest_hour) {
                    greatest_hour = h
                }
                
            }
            
            if(smallest_hour != greatest_hour) { // use smallest and greatest hour to fill in hours array
                
                for i in 0..<(greatest_hour-smallest_hour) {
                    hours.append(smallest_hour+i)
                }
            } else {
                hours.append(smallest_hour)
            }
            
            for i in 0..<(60/5) {
                mins.append(i*5)
            }
        }
        
        picker.delegate = self
        picker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0) {
            return days.count
        } else if(component == 1) {
            return hours.count
        } else if(component == 2) {
            return mins.count
        } else {
            return period.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(component == 0) {            // DAYS
            
            return days[row]
            
        } else if(component == 1) {     // HOURS
            
            return String(hours[row])
            
        } else if(component == 2) {     // MINUTES
            
            if(mins[row] == 0) {
                return "00"
            } else {
                return String(mins[row])
            }
            
        } else {                        // PERIOD
            
            return period[row]
            
        }
        
    }

}
