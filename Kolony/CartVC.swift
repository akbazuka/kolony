//
//  CartVC.swift
//  Kolony
//
//  Created by Kedlaya on 3/2/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import UIKit

class CartVC: UIViewController {
    
    @IBOutlet weak var cartCollectionView: UICollectionView!
    
    let attributes = [NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 10)!] //For changing font of navigation bar title
    
    var feedItems: NSArray = NSArray() //(Uncomment if using database)
    var selectedLocation : ProductsModel = ProductsModel() //(Uncomment if using database)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //For getting data from database
        let homeModel = HomeModel() //(Uncomment if using database)
        homeModel.delegate = self   //(Uncomment if using database)
        homeModel.downloadItems()   //(Uncomment if using database)
        
    }
    
}
// (Uncomment if using database)
//MARK: Database Model
extension CartVC: HomeModelProtocol {
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.cartCollectionView.reloadData()
    }
}

//MARK: Products View Stuff (Collection View)
extension CartVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return feedItems.count //(Uncomment if using database)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Create cell
        let cartCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cartCell", for: indexPath) as! CartCell
        
        //cell.productImage.image = images[indexPath.row] //Places image of a certain index of image array in indexPath of imageview of cell
        
        
        //Get data of product by cell (from database)
        //let item: ProductsModel = feedItems[indexPath.row] as! ProductsModel //(Uncomment if using database)
        
        // Get references to labels of cell
        //cell.productDescription.text = item.name //(Uncomment if using database)
        
        //cell.productPrice.text = item.price //Uncomment if using database
        
        return cartCell
    }
}
