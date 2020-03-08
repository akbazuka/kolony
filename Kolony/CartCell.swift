//
//  CartCell.swift
//  Kolony
//
//  Created by Kedlaya on 3/2/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import UIKit

class CartCell: UICollectionViewCell {
    
    @IBOutlet weak var cartImage: UIImageView!
    @IBOutlet weak var cartName: UILabel!
    @IBOutlet weak var cartPrice: UILabel!
    @IBOutlet weak var cartSize: UILabel!
    @IBOutlet weak var removeItemBtn: UIButton!
    
    override func layoutSubviews() {
        cartName.lineBreakMode = .byWordWrapping
        cartName.adjustsFontSizeToFitWidth = true
        
        //Add border and change color of remove Item Button
        removeItemBtn.layer.cornerRadius = 5
        removeItemBtn.layer.borderWidth = 2
        removeItemBtn.layer.borderColor = UIColor.black.cgColor
    }
}
