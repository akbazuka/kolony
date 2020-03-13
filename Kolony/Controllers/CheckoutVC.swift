//
//  CheckoutVC.swift
//  Kolony
//
//  Created by Kedlaya on 3/13/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import UIKit

class CheckoutVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var tableVIew: UITableView!
    
    @IBOutlet weak var paymentMethodBtn: UIButton!
    @IBOutlet weak var shippingMethodBtn: UIButton!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var processingFeeLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var placeHolderView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func placeOrderOnClick(_ sender: Any) {
    }
    @IBAction func paymentMethodOnClick(_ sender: Any) {
    }
    @IBAction func shippingMethodOnClick(_ sender: Any) {
    }
    
}
