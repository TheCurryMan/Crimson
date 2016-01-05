//
//  CustomSlider.swift
//  NewsOTG
//
//  Created by Avinash Jain on 1/5/16.
//  Copyright © 2016 Avinash Jain. All rights reserved.
//
import UIKit

class CustomSlider: UISlider {
    
    var sliderIdentifier: Int!
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        sliderIdentifier = 0
    }
    
}
