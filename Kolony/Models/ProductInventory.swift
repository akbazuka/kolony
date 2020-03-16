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
import Firebase

struct ProductInventory {
    //Properties
    var id: String
    //var images: [String] //Array of images
    var product: String
    var size: Double
    var soldOut: Bool
    var stock: Int
    
    //Constructor
    init(id: String, product: String, size: Double, soldOut: Bool, stock: Int) {
        self.id = id
        self.product = product
        self.size = size
        self.soldOut = soldOut
        self.stock = stock
    }
    
    //Constructor
    init(data: [String: Any]) {
        self.id = data["id"] as? String ?? ""
        self.product = data["product"] as? String ?? ""
        self.size = data["size"] as? Double ?? 0.0
        self.soldOut = data["soldOut"] as? Bool ?? false
        self.stock = data["stock"] as? Int ?? 0
    }
}

//For running firstIndex(of:) method in Stripe Cart file to remove items
extension ProductInventory : Equatable {
    static func ==(lhs: ProductInventory, rhs: ProductInventory) -> Bool {
        return lhs.id == rhs.id
    }
}
