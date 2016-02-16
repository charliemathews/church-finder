//
//  FilterViewCell.swift
//  ChurchFinder
//
//  Created by Sarah Burgess on 2/8/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//

import UIKit

class FilterViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var filterCategoryLabel: UILabel!
    @IBOutlet var view: UIView!
    @IBOutlet weak var filterCategoryPicker: UIPickerView!
    var labelText: String!
    var pickerLabels = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        filterCategoryPicker.delegate = self
        filterCategoryPicker.dataSource = self
        self.view.bringSubviewToFront(view)
    }
    func initialize(lT: String, pL: [String]){
        labelText = lT
        pickerLabels = pL
        filterCategoryLabel.text = labelText

    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerLabels.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerLabels[row]
    }
    

}
