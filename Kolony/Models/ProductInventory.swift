//
//  ProductInventory.swift
//  Kolony
//
//  Created by Kedlaya on 3/11/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

/**
 ProductInventory Model
 */
import Foundation
import FirebaseFirestore

struct ProductInventory {
    //Properties
    var id: String
    //var images: [String] //Array of images
    var product: String
    var size: String
    var stock: Int
    
    //Constructor
    init(data: [String: Any]) {
        self.id = data["id"] as? String ?? ""
        self.product = data["product"] as? String ?? ""
        self.size = data["size"] as? String ?? "0"
        self.stock = data["stock"] as? Int ?? 0
    }
}
