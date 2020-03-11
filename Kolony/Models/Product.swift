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
    var images: [String] //Array of images
    var price: Double
    var brand: String
    var colorway: String
    var retail: Int
    var style: String
    var release: String //Type depending on how stored in Firebase
    var timeStamp: Timestamp
}

