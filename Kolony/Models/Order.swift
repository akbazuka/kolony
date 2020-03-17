//
//  Order.swift
//  Kolony
//
//  Created by Kedlaya on 3/16/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

struct Order {
    //Properties
    var id: String
    var productImages: String
    var productName: String
    var productSize: Double
    var productInventoryId: String
    var productPrice: Double
    var timeStamp: Timestamp
    var user: String
    
//    //Constructor
//    init(id: String, productInventoryId: String, timeStamp: Timestamp, user: String) {
//        self.id = id
//        self.productInventoryId = productInventoryId
//        self.timeStamp = timeStamp
//        self.user = user
//    }
    
    //Constructor
    init(data: [String: Any]) {
        self.id = data["id"] as? String ?? ""
        self.productImages = data["productImages"] as? String ?? ""
        self.productName = data["productName"] as? String ?? ""
        self.productSize = data["productSize"] as? Double ?? 0.0
        self.productInventoryId = data["productInventoryId"] as? String ?? ""
        self.productPrice = data["productPrice"] as? Double ?? 0.0
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
        self.user = data["user"] as? String ?? ""
    }
}
