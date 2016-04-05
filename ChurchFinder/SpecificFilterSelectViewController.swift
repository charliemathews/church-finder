/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Mike Curtis
Created: 03/07/16
*/

import UIKit

protocol specificFilterViewControllerDelegate{
    func doneWithSpecificFilter(child: SpecificFilterSelectViewController)
}

class SpecificFilterSelectViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    var delegate: specificFilterViewControllerDelegate!
    var selectedPickerValue: String!
    var pickerName: String!
    var pickerValues: [String]!
    @IBOutlet var filterPicker: UIPickerView!
    
    @IBOutlet var filterLabel: UILabel!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        filterLabel.text = "Filter " + pickerName
        filterPicker.delegate = self
        filterPicker.dataSource = self
         selectedPickerValue = pickerValues[0]
    }
    
    @IBAction func done(sender: AnyObject) {
        delegate.doneWithSpecificFilter(self)
    }
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if(pickerName == "times"){
            return 2
        }
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerValues[row]
    }
    func pickerView(pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int){
            selectedPickerValue = pickerValues[row] as String
            NSLog(selectedPickerValue)
    }
}
