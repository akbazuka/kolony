//
//  OrderCell.swift
//  Kolony
//
//  Created by Kedlaya on 3/16/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {
    
    //Outletes
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderSize: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var orderDate: UILabel!

    //Variables
    private var item: ProductInventory!
    //weak var delegate: OrderCellDelegate?

    override func layoutSubviews() {
        //cartName.lineBreakMode = .byWordWrapping
        orderName.adjustsFontSizeToFitWidth = true
    }

    override func awakeFromNib() {
           super.awakeFromNib()
       }

    func configureCell(productInventory: ProductInventory, product: Product/*, delegate: OrderCellDelegate*/){
        //self.delegate = delegate
        self.item = productInventory

        orderName.text = product.name
        orderSize.text = "Size: \(NSNumber(value: productInventory.size).stringValue)"

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

        if let price = formatter.string(from: product.price as NSNumber){
            orderPrice.text = price
        }

        if let url = URL(string: product.images) {
            orderImage.kf.setImage(with: url)
        }
    }
}
