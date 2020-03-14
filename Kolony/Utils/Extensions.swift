//
//  Extensions.swift
//  Kolony
//
//  Created by Kedlaya on 3/13/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import UIKit
import Firebase

extension Int{
    
    func penniesToFormattedCurrency() -> String{
        //Int to dollars: Eg: 124 -> 1.24
        let dollars = Double(self) / 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let dollarString = formatter.string(from: dollars as NSNumber) {
            return dollarString
        }
        
        return "$0.00"
    }
}
