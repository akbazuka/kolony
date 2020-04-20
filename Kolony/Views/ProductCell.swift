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
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    override func layoutSubviews() {
        productName.adjustsFontSizeToFitWidth = true
        
    }
    
    func configureCell (product:Product) {
        productName.text = product.name
        //productImage.image = product.images[0] //First image
        
        productPrice.text = product.price.asUSCurrency
    }
}
