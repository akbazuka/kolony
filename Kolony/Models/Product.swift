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
}

