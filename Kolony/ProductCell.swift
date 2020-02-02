//
//  ProductCell.swift
//  Kolony
//
//  Created by Kedlaya on 1/29/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productDescription: UILabel!
    
    override func layoutSubviews() {
        productDescription.adjustsFontSizeToFitWidth = true
        
    }
}
