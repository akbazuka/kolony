//
//  Inventory.swift
//  Kolony
//
//  Created by Kedlaya on 4/16/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Inventory {
    //Properties
    var id: String
    var product: String
    var size: Double
    var sold: Bool
    var supplier: String
    var timeStamp: Timestamp
    
    //Constructor
    init(id: String, product: String, size: Double, sold: Bool, supplier: String, timeStamp: Timestamp){
        self.id = id
        self.product = product
        self.size = size
        self.sold = sold
        self.supplier = supplier
        self.timeStamp = timeStamp
    }
    
    static func modelToData(inventory: Inventory) -> [String: Any]{
        let data: [String:Any] = [
            "id" : inventory.id,
            "product" : inventory.product,
            "size" : inventory.size,
            "sold" : inventory.sold,
            "supplier": inventory.supplier,
            "timeStamp" : inventory.timeStamp
        ]
        return data
    }
}
