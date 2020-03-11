//
//  CartProductsModel.swift
//  Kolony
//
//  Created by Kedlaya on 3/7/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import Foundation
 
class CartProductsModel: NSObject {
    
    //Properties
    //var image: String?
    var name: String?
    var price: String?
    var size: String?
    var individualID: String?
    //var images: String?
    var prodID: String?
    var productBrand: String?
    var colorway: String?
    var retail: String?
    var style: String?
    var prodRelease: String?
    
    //Empty constructor
    override init()
    {
        
    }
    
    //Construct with @name, @brand, @size, @colorway, @price, @retail, @style and @release parameters
    init(individualID: String, prodID: String, size: String, price: String, name: String, brand: String, colorway: String, retail: String, style: String, prodRelease: String) {
        
        self.name = name
        self.price = price
        self.size = size
        self.individualID = individualID
        self.prodID = prodID
        self.productBrand = brand
        self.colorway = colorway
        self.retail = retail
        self.style = style
        self.prodRelease = prodRelease
        
    }
    
    
    //Prints object's current state
    override var description: String {
        return "Name: \(String(describing: name)), Product Price: \(String(describing: price)), Size: \(String(describing: size)), Individual ID: \(String(describing: individualID)), Product ID: \(String(describing: prodID)), Product Brand: \(String(describing: productBrand)), Product Colorway: \(String(describing: colorway)), Product Retail: \(String(describing: retail)), Product Style: \(String(describing: style)), Product Release: \(String(describing: prodRelease)),"
    }
}

