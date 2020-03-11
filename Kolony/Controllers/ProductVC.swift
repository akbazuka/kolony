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
    
    static var prodID = ""
    
    static var prodName = ""            //static to reference in MainVC
    
    static var prodPrice = Double()
    
    static var prodBrand = ""
    
    static var prodStyle = ""
    
    static var prodColorway = ""
    
    static var prodRelease = ""
    
    static var prodRetail = Int()
    
    ////Use only if want to display size of item in cart in detail view as well
    ////Only used when product coming from CartVC
    //static var prodSize = ""
    
    //Use only if want to display size of item in cart in detail view as well
    //static var sizeSelected = 0 //To make sure that user chooses size from picker before adding to cart
    
    var feedItems: NSArray = NSArray() //(Uncomment if using database)
    var selectedLocation1 : SizeProductModel = SizeProductModel() //(Uncomment if using database)
    
    fileprivate let pickerView = ToolbarPickerView()
    //fileprivate let sizes = ["5","6", "7", "8", "9", "10", "11"]
    var selectedItemID = ""
    
    //Text box that allows you to select size and then displays it
    @IBOutlet weak var sizeText: UITextField!
    
    let attributes = [NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 10)!] //For changing font of navigation bar title
    
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Changes back button title in navigation controller to "Back"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        //Refresh Size picker every time user navigates to ProductVC
        didTapCancel()
        
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
        
        //Convert Price fro Double to Currency to be displayed
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: ProductVC.prodPrice as NSNumber) {
            productPrice.text = "$"+price
        }
        brandLabel.text = ProductVC.prodBrand.uppercased()
        styleLabel.text = ProductVC.prodStyle.uppercased()
        colorwayLabel.text = ProductVC.prodColorway.uppercased()

        releaseLabel.text = String(ProductVC.prodRelease)
        
        //Convert Retail from Int to Currency to be displayed
        formatter.numberStyle = .currency
        if let retail = formatter.string(from: ProductVC.prodRetail as NSNumber) {
            productPrice.text = "$"+retail
        }
        
        ////Use only if want to display size of item in cart in detail view as well
        //sizeText.text = ProductVC.prodSize //Only displays a size when information sent from CartVC
        
        //UINavigationBar.appearance().titleTextAttributes = attributes //Changes font of navigation bar title
        
        //UIPickerView with Done Button
        self.sizeText.inputView = self.pickerView
        self.sizeText.inputAccessoryView = self.pickerView.toolbar

        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.toolbarDelegate = self

        self.pickerView.reloadAllComponents()
        /***********************************************/
        
        //For getting data from database
        let homeModel = HomeModel() //(Uncomment if using database)
        homeModel.delegate = self   //(Uncomment if using database)
        homeModel.downloadItemSizes()   //(Uncomment if using database)
    }

    @IBAction func addToCartOnClick(_ sender: Any) {
        //if(isKeyPresentInUserDefaults(key: "uID")){ //Not as good as validating if guest user
        
        //Only allows to add to cart if user is logged in with a valid account and not as guest user and size is picked
        if LoginVC.isGuest == 0, let size = sizeText.text, !size.isEmpty/*, ProductVC.sizeSelected == 1 */{
            //Add item to cart in the database
            insertCart(uID: UserDefaults.standard.string(forKey: "uID") ?? "-1", selectedProductID: self.selectedItemID)
            
            //Refresh Size picker so that when user navigates back, they cannot re-add to cart
            self.didTapCancel()
            
            ////Use only if want to display size of item in cart in detail view as well
            //ProductVC.sizeSelected = 0 //Does not allow user to add to cart again without reselecting size
            
            //Show alert saying item was added to cart
            alertNavToVC(title: "Added to Cart", message: "This item was successfully added to your shopping cart!",toVC: "CartVC")
            
        } else if (LoginVC.isGuest != 0) {
            alert(title: "Error", message: "You must be logged in with a registered account if you would like to add this item to your shopping cart.")
        }   ////Use only if want to display size of item in cart in detail view as well
            /*else if ProductVC.sizeSelected == 0, let size = sizeText.text, !size.isEmpty{ //Does not allow user to add to cart if coming straight from CartVC and has not manually rechose a size
            self.didTapCancel()
            alert(title: "This item is already in your Cart", message: "Please select a size again if you wish to add the item once more.")
        } */else {
            alert(title: "Please select a Size", message: "You must select a size for the product you wish to add to your cart.")
        }
    }
    
    //To check if a user defualt exists
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    @IBAction func tryOnClicked(_ sender: Any) {
        //
    }
    
    //Push product into user's cart in database
    func insertCart(uID: String, selectedProductID: String){
        
        //Create url string
        let urlString = SignUpVC.self.dataURL + "insertCart&uID=\(uID)&indiProductID=\(selectedProductID)"
        
        //Encode url
        let result = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Error"
        
        //Create url
        guard let url = URL(string: result) else { return }
        
        //Send url
        URLSession.shared.dataTask(with: url).resume()
        
        print("URL Sent: \(url)")
    }
    
    //Alert Popup
    func alert(title: String, message: String) {
        
        //Error Title
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Action Title
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //Present to Screen
        present(alert,animated: true, completion: nil)
    }
    
    //Navigate to VC after Alert
    func alertNavToVC(title:String, message: String, toVC: String) {
        //Error Title
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Action Title
        //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default){UIAlertAction in self.navGoTo(toVC, animate: true)})
        
        //Present to Screen
        present(alert,animated: true, completion: nil)
    }
    
    //Navigate to different VC manually (With Navigation Controller)
    func navGoTo(_ view: String, animate: Bool){
        OperationQueue.main.addOperation {
            func topMostController() -> UIViewController {
                var topController: UIViewController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.rootViewController!
                while (topController.presentedViewController != nil) {
                    topController = topController.presentedViewController!
                }
                return topController
            }
            if let second = topMostController().storyboard?.instantiateViewController(withIdentifier: view) {
        self.navigationController?.pushViewController(second, animated: animate)
                
            }
        }
    }
    
}

/*Delegate methods of UIPickerView*/
//MARK: UIPickerView Delegates
extension ProductVC: UIPickerViewDataSource, UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return feedItems.count
        //return sizes.count
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    /*
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.sizes[row]
    }*/

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let item: SizeProductModel = feedItems[row] as! SizeProductModel
        return item.size
    }
    
    /*
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.sizeText.text = self.sizes[row]
    }*/
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let item: SizeProductModel = feedItems[row] as! SizeProductModel
        self.sizeText.text = item.size
    }
}

/*Done button of picker*/
//MARK: UIPickerView Done Button
extension ProductVC: ToolbarPickerViewDelegate {

    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        
        //To change title of button
        //self.sizeBtn.setTitle(self.titles[row], for: .normal)
        //self.sizeBtn.resignFirstResponder()
        
        let item: SizeProductModel = feedItems[row] as! SizeProductModel
        
        self.sizeText.text = item.size
        self.sizeText.resignFirstResponder()
        
        //Selects product according to size chosen
        self.selectedItemID = item.individualID ?? "0"
        
        ////Use only if want to display size of item in cart in detail view as well
        //ProductVC.sizeSelected = 1 //User has selected a size; allow it to be added ot cart
    }

    func didTapCancel() {
        self.sizeText.text = nil
        self.sizeText.resignFirstResponder()
        
        //Resets selected item
        self.selectedItemID = ""
        
    }
}

// (Uncomment if using database)
//MARK: Database Stuff
extension ProductVC: HomeModelProtocol {
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.pickerView.reloadAllComponents()
    }
}
