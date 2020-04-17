//
//  CartCell.swift
//  Kolony
//
//  Created by Kedlaya on 3/2/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//
/*
 Custom UITableVIew Cell Class
 */

import UIKit

protocol CartCellDelegate: class {
    func removeItem(productInventory: ProductInventory)
}

class CartCell: UITableViewCell {
    
    //Outletes
    @IBOutlet weak var cartImage: UIImageView!
    @IBOutlet weak var cartName: UILabel!
    @IBOutlet weak var cartPrice: UILabel!
    @IBOutlet weak var cartSize: UILabel!
    @IBOutlet weak var removeItemBtn: UIButton!
    
    //Variables
    private var item: ProductInventory!
    weak var delegate: CartCellDelegate?
    
    override func layoutSubviews() {
        //cartName.lineBreakMode = .byWordWrapping
        cartName.adjustsFontSizeToFitWidth = true
        
        ////Add border and change color of remove Item Button
        //removeItemBtn.layer.cornerRadius = 5
        //removeItemBtn.layer.borderWidth = 2
        //removeItemBtn.layer.borderColor = UIColor.black.cgColor
    }
    
    override func awakeFromNib() {
           super.awakeFromNib()
       }
    
    func configureCell(productInventory: ProductInventory, product: Product, delegate: CartCellDelegate){
        self.delegate = delegate
        self.item = productInventory
        
        cartName.text = product.name
        cartSize.text = "Size: \(NSNumber(value: productInventory.size).stringValue)"
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let price = formatter.string(from: product.price as NSNumber){
            cartPrice.text = price
        }
        
        if let url = URL(string: product.images) {
            cartImage.kf.setImage(with: url)
        }
    }
    
    @IBAction func removeItemOnClick(_ sender: Any) {
        //print("Yeet")
        delegate?.removeItem(productInventory: item)
    }
}
