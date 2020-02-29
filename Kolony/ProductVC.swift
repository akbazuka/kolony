//
//  ProductView.swift
//  Kolony
//
//  Created by Kedlaya on 2/1/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import UIKit

class ProductVC: UIViewController {
    
    @IBOutlet weak var productImages: UIImageView!
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var addToCartBtn: UIButton!
    
    @IBOutlet weak var tryBtn: UIButton!
    
    @IBOutlet weak var sizeBtn: UIButton!
    
    @IBOutlet weak var brandLabel: UILabel!
    
    @IBOutlet weak var styleLabel: UILabel!
    
    @IBOutlet weak var colorwayLabel: UILabel!
    
    @IBOutlet weak var releaseLabel: UILabel!
    
    @IBOutlet weak var retailLabel: UILabel!
    
    static var prodPic : UIImage? = nil //static to reference in MainVC
    
    static var prodName = ""            //static to reference in MainVC
    
    static var prodPrice = ""
    
    static var prodSize = ""
    
    static var prodBrand = ""
    
    static var prodStyle = ""
    
    static var prodColorway = ""
    
    static var prodRelease = ""
    
    static var prodRetail = ""
    
    //let attributes = [NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 10)!] //For changing font of navigation bar title
    
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Wrap text to next line if doesn't fit on same line
        productName.lineBreakMode = .byWordWrapping // notice the 'b' instead of 'B'
        productName.numberOfLines = 0
        
        //Changes Add To Cart Button Attributes
        //addToCartBtn.backgroundColor = .clear
        addToCartBtn.layer.cornerRadius = 5
        addToCartBtn.layer.borderWidth = 2
        addToCartBtn.layer.borderColor = UIColor.black.cgColor
        //addToCartBtn.setTitleColor(.systemBlue, for: .highlighted)
        
        //Customize Try Before Buy Button
        //tryBtn.backgroundColor = .black
        tryBtn.layer.cornerRadius = 5
        tryBtn.layer.borderWidth = 1
        tryBtn.layer.borderColor = UIColor.white.cgColor

        //Customize Size Button
        sizeBtn.layer.cornerRadius = 5
        sizeBtn.layer.borderWidth = 1
        sizeBtn.layer.borderColor = UIColor.white.cgColor
        
        //Make Information Labels Uppercase
        brandLabel.text = brandLabel.text?.uppercased()
        
        styleLabel.text = styleLabel.text?.uppercased()
        
        colorwayLabel.text = colorwayLabel.text?.uppercased()
        
        releaseLabel.text = releaseLabel.text?.uppercased()
        
        retailLabel.text = retailLabel.text?.uppercased()
        
        //Sets product info according to what product was clicked on
        productImages.image = ProductVC.prodPic
        productName.text = ProductVC.prodName
        
        //UINavigationBar.appearance().titleTextAttributes = attributes //Changes font of navigation bar title
    }

    @IBAction func addToCartOnClick(_ sender: Any) {
        //
    }
    
    @IBAction func tryOnClicked(_ sender: Any) {
        //
    }
    
    @IBAction func sizeOnClicked(_ sender: Any) {
        //
    }
    
}
