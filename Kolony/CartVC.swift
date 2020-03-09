//
//  CartVC.swift
//  Kolony
//
//  Created by Kedlaya on 3/2/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import UIKit

class CartVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var checkoutView: UIView!
    
    @IBOutlet weak var cartEmptyLabel: UILabel!
    
    let attributes = [NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 10)!] //For changing font of navigation bar title
    
    var feedItems: NSArray = NSArray()
    var selectedLocation : CartProductsModel = CartProductsModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide checkout view if user is logged in as guest
        if (LoginVC.isGuest == 1) {
            checkoutView.isHidden = true
        }
        else {
            checkoutView.isHidden = false
        }
        
        //Border for checkoutView
        checkoutView.layer.borderWidth = 0.5
        checkoutView.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        
        //For getting data from database
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.downloadItemsCart()
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
    
    /*//Only need if using Checkout button in Navigation Bars
    //#selector method to navigate to checkout
    @objc func goToCheckout(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let checkoutViewController = storyBoard.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        //self.present(nextViewController, animated:true, completion:nil)
        print("Hola")
        self.navigationController?.pushViewController(checkoutViewController, animated: true)
    }
 */
    
}

//MARK: Products View Stuff (Collection View)
extension CartVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //print("The count is: \(feedItems.count)")
        
        //Hide cart empty label if user not logged in as guest and if user is logged in, change the label's text
        if LoginVC.isGuest == 0 && feedItems.count != 0{
            cartEmptyLabel.isHidden = true
        
            ////Create bar button item for checkout
            //let checkoutBtn = UIBarButtonItem(title: "Checkout", style: .done, target: self, action: #selector(goToCheckout))
            ////Show checkout button in Navigation Bar only if cart is not empty and user is logged in
            //self.navigationItem.rightBarButtonItem  = checkoutBtn
            
            //Show checkout view if items in cart
            checkoutView.isHidden = false
            
        } else if LoginVC.isGuest == 0 && feedItems.count == 0 {
            cartEmptyLabel.isHidden = false
            cartEmptyLabel.text = "Your cart is empty."
            
            //Hide checkout view if cart is empty
            checkoutView.isHidden = true
            
            //Remove checkput button if cart is empty
            self.navigationItem.rightBarButtonItem = nil
        }
        return feedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Create cell
        let cartCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cartCell", for: indexPath) as! CartCell
        
        //Get data of product by cell (from database)
        let item: CartProductsModel = feedItems[indexPath.row] as! CartProductsModel
        
        // Get references to labels of cell
        cartCell.cartName.text = item.name
        //print("The name is: "+(cartCell.cartName.text ?? "Does not exist"))
        
        cartCell.cartPrice.text = item.price
        
        cartCell.cartSize.text = "Size: \(item.size ?? "-1")"
        
        //Remove Item Button
        //cartCell.removeItemBtn?.setValue(indexPath.row, forKey: "index")
        //Call removeItemFunc
        
        //Send parameter individualID by using tag property and converting String to Int here
        cartCell.removeItemBtn.tag = Int(item.individualID ?? "-1") ?? -1
        //Programatically send button in cell to removeItem function when clicked (.touchUpInside)
        cartCell.removeItemBtn.addTarget(self, action: #selector(removeItem), for: .touchUpInside)
        
        //Image View
        //cartCell.cartImage.image = ...
        
        //Give Each Product in CartVC a black rounded border
        cartCell.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
        cartCell.layer.borderWidth = 0.5
        cartCell.layer.cornerRadius = 7
        
//        //Add shadow to each cell
//        cartCell.layer.shadowColor = UIColor.black.cgColor
//        cartCell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
//        cartCell.layer.shadowRadius = 1.0
//        cartCell.layer.shadowOpacity = 0.5
//        cartCell.layer.masksToBounds = false
        
        return cartCell
    }
    
    @objc func removeItem(sender:UIButton){
        //Convert individualID back to String
        let individualID = String(sender.tag)
        
        //Update database to remove item from cart table
        removeFromCart(uID: UserDefaults.standard.string(forKey: "uID") ?? "-1", selectedProductID: individualID)
        
        //self.collectionView.reloadData() //Not working; don't understand why
        
        //Reload screen immediately to reflect changes made in database
        self.viewDidLoad() //Doesn't always work
    }
    
    //Remove product from user's cart in database
    func removeFromCart(uID: String, selectedProductID: String){
        
        //Create url string
        let urlString = SignUpVC.self.dataURL + "removeFromCart&uID=\(uID)&indiProductID=\(selectedProductID)"
        
        //Encode url
        let result = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Error"
        
        //Create url
        guard let url = URL(string: result) else { return }
        
        //Send url
        URLSession.shared.dataTask(with: url).resume()
        
        print("URL Sent: \(url)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Get data of product by cell (from database)
        let item: CartProductsModel = feedItems[indexPath.row] as! CartProductsModel //(Uncomment if using database)
           
        //Sending infromation to be displayed on ProductVC
        
        //ProductVC.prodPic = images[indexPath.row] //Implement image
        ProductVC.prodName = item.name ?? "Name"
        ProductVC.prodPrice = item.price ?? "$$$"
        ProductVC.prodBrand = item.productBrand ?? "Brand"
        ProductVC.prodStyle = item.style ?? "Style"
        ProductVC.prodColorway = item.colorway ?? "Colorway"
        ProductVC.prodRelease = item.prodRelease ?? "Release Date"
        ProductVC.prodRetail = item.retail ?? "Retail Price"
        ProductVC.prodID = item.prodID ?? "Product ID"
        ////Use only if want to display size of item in cart in detail view as well
        //ProductVC.prodSize = item.size ?? "-1"
        
        //Go to Detail View of Product
        navGoTo("ProductVC", animate: true)
    }
}

//MARK: Database Model
extension CartVC: HomeModelProtocol {
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.collectionView.reloadData()
    }
}

