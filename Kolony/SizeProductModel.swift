//
//  SizeProductModel.swift
//  Kolony
//
//  Created by Kedlaya on 3/7/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import Foundation
 
class SizeProductModel: NSObject {
    
    //Properties
    var individualID: String?
    //var images: String?
    var prodID: String?
    var size: String?
    
    //Empty constructor
    override init()
    {
        
    }
    
    //Construct with @name, @brand, @size, @colorway, @price, @retail, @style and @release parameters
    init(individualID: String, prodID: String, size: String) {
        
        self.individualID = individualID
        self.prodID = prodID
        self.size = size
        
    }
    
    
    //Prints object's current state
    override var description: String {
        return "Individual ID: \(String(describing: individualID)), Product ID: \(String(describing: prodID)), Size: \(String(describing: size))"
    }
}
