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
        
        //Hide cart empty label if user not logged in as guest and if user is logged in, change the label's text
        if LoginVC.isGuest == 0{
            cartEmptyLabel.isHidden = true
        } else if LoginVC.isGuest == 0 && feedItems.count == 0 {
            cartEmptyLabel.text = "Your cart is empty."
        }
        
        //For getting data from database
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.downloadItemsCart()
    }
    
}

//MARK: Products View Stuff (Collection View)
extension CartVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //print("The count is: \(feedItems.count)")
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
        
        ////Remove Item Button
        //cartCell.removeItemBtn?.setValue(indexPath.row, forKey: "index")
        ////Call removeItemFunc
        //cartCell.removeItemBtn?.addTarget(self, action: #selector(UIPushBehavior.removeItem(_:)), for: UIControl.Event.touchUpInside)
        
        //Image View
        //cartCell.cartImage.image = ...
        
        return cartCell
    }
    
    func removeItem(sender:UIButton){
        let i : Int = (sender.layer.value(forKey: "index")) as! Int
        
        //Update database to remove item from cart table here
        //userNames.removeAtIndex(i)
        print(i)
        
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*
           //Get data of product by cell (from database)
           let item: ProductsModel = feedItems[indexPath.row] as! ProductsModel //(Uncomment if using database)
           
           ProductVC.prodPic = images[indexPath.row]
           ProductVC.prodName = item.name ?? "Name"
           ProductVC.prodPrice = item.price ?? "$$$"
           ProductVC.prodBrand = item.brand ?? "Brand"
           ProductVC.prodStyle = item.style ?? "Style"
           ProductVC.prodColorway = item.colorway ?? "Colorway"
           ProductVC.prodRelease = item.release ?? "Release Date"
           ProductVC.prodRetail = item.retail ?? "Retail Price"
           ProductVC.prodID = item.id ?? "Product ID"
           
           navGoTo("ProductVC", animate: true) */
       }
}

//MARK: Database Model
extension CartVC: HomeModelProtocol {
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.collectionView.reloadData()
    }
}

