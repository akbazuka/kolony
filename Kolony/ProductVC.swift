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
    
    @IBOutlet weak var productPrice: UILabel!
    
    static var prodPic : UIImage? = nil //static to reference in MainVC
    
    static var prodName = ""            //static to reference in MainVC
    
    static var prodPrice = ""           //""
    
    static var prodSize = ""            //""
    
    static var prodBrand = ""
    
    static var prodStyle = ""
    
    static var prodColorway = ""
    
    static var prodRelease = ""
    
    static var prodRetail = ""
    
    fileprivate let pickerView = ToolbarPickerView()
    fileprivate let sizes = ["5","6", "7", "8", "9", "10", "11"]
    @IBOutlet weak var textField: UITextField!
    
    let attributes = [NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 10)!] //For changing font of navigation bar title
    
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Changes back button title in navigation controller to "Back"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)

        
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
        sizeBtn.isEnabled = false
        sizeBtn.layer.cornerRadius = 5
        //sizeBtn.layer.borderWidth = 1
        //sizeBtn.layer.borderColor = UIColor.white.cgColor
        
        //Make Information Labels resize to fit inside container
        brandLabel.adjustsFontSizeToFitWidth = true
        styleLabel.adjustsFontSizeToFitWidth = true
        colorwayLabel.adjustsFontSizeToFitWidth = true
        releaseLabel.adjustsFontSizeToFitWidth = true
        retailLabel.adjustsFontSizeToFitWidth = true
        
        /***********************************************/
        
        //Sets product info according to what product was clicked on in collection view of MainVC
        productImages.image = ProductVC.prodPic
        productName.text = ProductVC.prodName
        productPrice.text = ProductVC.prodPrice
        brandLabel.text = ProductVC.prodBrand.uppercased()
        styleLabel.text = ProductVC.prodStyle.uppercased()
        colorwayLabel.text = ProductVC.prodColorway.uppercased()
        releaseLabel.text = ProductVC.prodRelease
        retailLabel.text = ProductVC.prodRetail
        
        //UINavigationBar.appearance().titleTextAttributes = attributes //Changes font of navigation bar title
        
        //UIPickerView with Done Button
        self.textField.inputView = self.pickerView
        self.textField.inputAccessoryView = self.pickerView.toolbar

        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.toolbarDelegate = self

        self.pickerView.reloadAllComponents()
        /***********************************************/
    }

    @IBAction func addToCartOnClick(_ sender: Any) {
        //
    }
    
    @IBAction func tryOnClicked(_ sender: Any) {
        //
    }
    
}

/*Delegate methods of UIPickerView*/
//MARK: UIPickerView Delegates
extension ProductVC: UIPickerViewDataSource, UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.sizes.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.sizes[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textField.text = self.sizes[row]
    }
}

/*Done button of picker*/
//MARK: UIPickerView Done Button
extension ProductVC: ToolbarPickerViewDelegate {

    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        
        //TO change title of button
        //self.sizeBtn.setTitle(self.titles[row], for: .normal)
        //self.sizeBtn.resignFirstResponder()
        
        self.textField.text = self.sizes[row]
        self.textField.resignFirstResponder()
    }

    func didTapCancel() {
        self.textField.text = nil
        self.textField.resignFirstResponder()
        
    }
}
