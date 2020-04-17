//
//  Product.swift
//  Kolony
//
//  Created by Kedlaya on 3/10/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

/**
 Product Model
 */
import Foundation
import FirebaseFirestore

struct Product {
    //Properties
    var id: String
    var name: String
    var images: String
    var image2: String
    var image3: String
    var image4: String
    var inventoryExists: Bool
    var price: Double
    var brand: String
    var colorway: String
    var retail: Double
    var style: String
    var release: Timestamp //Type depending on how stored in Firebase
    var timeStamp: Timestamp
    
    
    init(id: String, name: String, images: String, image2: String, image3: String, image4: String, price: Double, brand: String, colorway: String, retail: Double, style: String, release: Timestamp, timeStamp: Timestamp){
        
        self.id = id
        self.name = name
        self.images = images
        self.image2 = image2
        self.image3 = image3
        self.image4 = image4
        self.inventoryExists = true
        self.price = price
        self.brand = brand
        self.colorway = colorway
        self.retail = retail
        self.style = style
        self.release = release
        self.timeStamp = timeStamp
    }
    //Constructor
    init(data: [String: Any]) {
        self.id = data["id"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.images = data["images"] as? String ?? ""
        self.image2 = data["image2"] as? String ?? ""
        self.image3 = data["image3"] as? String ?? ""
        self.image4 = data["image4"] as? String ?? ""
        self.inventoryExists = data["inventoryExists"] as? Bool ?? true
        self.price = data["price"] as? Double ?? 0.00
        self.brand = data["brand"] as? String ?? ""
        self.colorway = data["colorway"] as? String ?? ""
        self.retail = data["retail"] as? Double ?? 0.00
        self.style = data["style"] as? String ?? ""
        self.release = data["release"] as? Timestamp ?? Timestamp()
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
    }
    
    static func modelToData(product: Product) -> [String: Any]{
        let data: [String:Any] = [
            "id" : product.id,
            "name" : product.name,
            "images" : product.images,
            "image2" : product.image2,
            "image3": product.image3,
            "image4" : product.image4,
            "brand" : product.brand,
            "price" : product.price,
            "retail" : product.retail,
            "release" : product.release,
            "style" : product.style,
            "colorway" : product.colorway,
            "inventoryExists" : true,
            "timeStamp" : product.timeStamp
        ]
        return data
    }
}

