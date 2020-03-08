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
    
    //Empty constructor
    override init()
    {
        
    }
    
    //Construct with @name, @brand, @size, @colorway, @price, @retail, @style and @release parameters
    init(individualID: String, prodID: String, size: String, price: String, name: String) {
        
        self.name = name
        self.price = price
        self.size = size
        self.individualID = individualID
        self.prodID = prodID
        
    }
    
    
    //Prints object's current state
    override var description: String {
        return "Name: \(String(describing: name)), Product Price: \(String(describing: price)), Size: \(String(describing: size)), Individual ID: \(String(describing: individualID)), Product ID: \(String(describing: prodID))"
    }
}

