//
//  StoreProducts.swift
//  Kolony
//
//  Created by Kedlaya on 3/1/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import Foundation
 
class ProductsModel: NSObject {
    
    //properties
    
    var name: String?
    //var images: String?
    var brand: String?
    var size: String? //int?
    var colorway: String?
    var price: String? //int?
    var retail: String?
    var style: String?
    var release: String? //date?
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @name, @brand, @size, @colorway, @price, @retail, @style and @release parameters
    
    init(name: String, brand: String, size: String, colorway: String, price: String, retail: String, style: String, release: String) {
        
        self.name = name
        self.brand = brand
        self.size = size
        self.colorway = colorway
        self.price = price
        self.retail = retail
        self.style = style
        self.release = release
        
    }
    
    
    //prints object's current state
    override var description: String {
        return "productname: \(name), productbrand: \(brand), productsize: \(size), productcolorway: \(colorway), productprice: \(price), productretail: \(retail), productstyle: \(style), productrelease: \(release)"
        
    }
    
    
}
