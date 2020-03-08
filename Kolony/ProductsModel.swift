//
//  StoreProducts.swift
//  Kolony
//
//  Created by Kedlaya on 3/1/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import Foundation
 
class ProductsModel: NSObject {
    
    //Properties
    var name: String?
    //var images: String?
    var brand: String?
    var colorway: String?
    var price: String? //int?
    var retail: String?
    var style: String?
    var release: String? //date?
    var id: String?
    
    
    //Empty constructor
    override init()
    {
        
    }
    
    //Construct with @name, @brand, @size, @colorway, @price, @retail, @style and @release parameters
    init(name: String, brand: String, colorway: String, price: String, retail: String, style: String, release: String, id: String) {
        
        self.name = name
        self.brand = brand
        self.colorway = colorway
        self.price = price
        self.retail = retail
        self.style = style
        self.release = release
        self.id = id
        
    }
    
    
    //Prints object's current state
    override var description: String {
        return "Name: \(String(describing: name)), Brand: \(String(describing: brand)), Colorway: \(String(describing: colorway)), Price: \(String(describing: price)), Retail: \(String(describing: retail)), Style: \(String(describing: style)), Release: \(String(describing: release)), ID: \(String(describing: id))"
        
    }
    
    
}
