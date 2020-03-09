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
    
    @IBOutlet weak var cartEmptyLabel: UILabel!
    
    let attributes = [NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 10)!] //For changing font of navigation bar title
    
    var feedItems: NSArray = NSArray()
    var selectedLocation : CartProductsModel = CartProductsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
}

//MARK: Products View Stuff (Collection View)
extension CartVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //print("The count is: \(feedItems.count)")
        
        //Hide cart empty label if user not logged in as guest and if user is logged in, change the label's text
        if LoginVC.isGuest == 0 && feedItems.count != 0{
            cartEmptyLabel.isHidden = true
        } else if LoginVC.isGuest == 0 && feedItems.count == 0 {
            cartEmptyLabel.isHidden = false
            cartEmptyLabel.text = "Your cart is empty."
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
        ProductVC.prodSize = item.size ?? "-1"
        
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

