//
//  ChurchListCellWithStar.swift
//  ChurchFinder
//
//  Created by Charles Mathews on 4/17/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//

import UIKit

class ChurchListCellWithStar: ChurchListCell {
    
    @IBOutlet weak var star: UIImageView!
    

    override func setCellInfo(resultIndex : Int) {
        let church = data.results[resultIndex] as Church
        
        displayInfo(church)
    }
    
    //after bookmark or unbookmark, redraw cell at path
}
