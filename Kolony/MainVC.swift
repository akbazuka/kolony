//
//  SwiftUIView.swift
//  Book Buddy
//
//  Created by Kedlaya on 1/25/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import UIKit

class MainVC: UIViewController{

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var MenuLeadingConstraint: NSLayoutConstraint!

    @IBOutlet weak var menuButton: UIButton!

    @IBOutlet weak var filterButton: UIButton!

    @IBOutlet weak var mainTintedV: UIView!
    
    @IBOutlet weak var menuView: UITableView!

    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var showMenu = false
    
    var tapGesture = UITapGestureRecognizer()
    
    var swipeLeft = UISwipeGestureRecognizer()
    
    var screenEdgeRecognizer: UIScreenEdgePanGestureRecognizer!

    let attributes = [NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 24)!] //For changing font of navigation bar title
    
    //Product Information (Hard Coded) Uncomment below section if not using database
    var images = [UIImage(named: "nikeAir"), UIImage(named: "yeezy")] //Array to test no. of cells in UICOllectionVew; Comment line when implement storing references to images in database
    /*
    var name = ["Jordan 1 Retro High Off-White University Blue", "adidas Yeezy Boost 350 V2 Yecheil (Non-Reflective)"]
    
    var price = ["$1,190","$270"]
    
    var brand = ["Nike", "adidas"]
    
    var style = ["AQ0818-148","FW5190"]
    
    var colorway = ["WHITE/DARK POWDER BLUE-CONE","Yecheil"]
    
    var release = ["06/23/2018","12/20/2019"]
    
    var retail = ["$190","$220"]
 */
    /*******************************************/

    var menuOptions = ["Settings", "Rate Us", "Sign Out"]
    
    var menuImages = [UIImage(named: "settingsPic"), UIImage(named: "ratePic"), UIImage(named: "exitPic")]
    
    var feedItems: NSArray = NSArray() //(Uncomment if using database)
    var selectedLocation : ProductsModel = ProductsModel() //(Uncomment if using database)
    
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        MenuLeadingConstraint.constant = -218 //Presents (default) menu bar to hide

        mainTintedV.isHidden = true //Hides tinted VC by default
        
        UINavigationBar.appearance().titleTextAttributes = attributes //Changes font of navigation bar title

        //Initialization of tap gesture for tinted view
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapOutsideMenu(_:)))
        mainTintedV.addGestureRecognizer(tapGesture)
        mainTintedV.isUserInteractionEnabled = true
        
        //Swipe left to close menu
        swipeLeft = UISwipeGestureRecognizer(target : self, action : #selector(self.leftSwipeMenu))
        
        swipeLeft.direction = .left
        menuView.addGestureRecognizer(swipeLeft)

        menuView.layer.cornerRadius = 10
        
        //Pan Right to open menu
        screenEdgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.openMenu))
        
        screenEdgeRecognizer.edges = .left

        mainView.addGestureRecognizer(screenEdgeRecognizer)
        
        //For getting data from database
        let homeModel = HomeModel() //(Uncomment if using database)
        homeModel.delegate = self   //(Uncomment if using database)
        homeModel.downloadItems()   //(Uncomment if using database)
    }
    

    //Menu opens and closes as hamburger button is pressed
    @IBAction func menuButtonPressed(_ sender: Any) {

    if (showMenu){ //When menu is visible
            closeMenu()
        }
        else { //When menu is not visible
            openMenu()
        }

//        showMenu = !showMenu //Either shows or hides menu depending on current state, when hamburger button is pressed
    }

    //When view is tapped outside the menu, the menu closes
    @objc func tapOutsideMenu(_ sender: UITapGestureRecognizer) {

        closeMenu()
        
        UIView.animate(withDuration: 0.4, animations:{
            self.view.layoutIfNeeded()

        })
    }

    //Set backgorund image for menu button to closed state
    func changeMenuImageClose() {
        menuButton.setImage(UIImage(named: "menuVert"), for: .normal) //Set backgorund image for menu button
    }

    //Set backgorund image for menu button to open state
    func changeMenuImageOpen() {
        menuButton.setImage(UIImage(named: "menuHoriz"), for: .normal) //Set backgorund image for menu button //Set backgorund image for menu button
    }
    
    @objc func leftSwipeMenu(_ sender: UISwipeGestureRecognizer) {
        
        closeMenu()

    }
    
    @objc func rightSwipeMenu(_ sender: UIScreenEdgePanGestureRecognizer) {
        
        openMenu()
    }
    
    func closeMenu() {
        
        MenuLeadingConstraint.constant = -218 //remove menu from view

        mainTintedV.isHidden = true //Hides tinted VC

        showMenu = false

        changeMenuImageClose()
        
        UIView.animate(withDuration: 0.5, animations:{
            self.view.layoutIfNeeded()})
    }
    
    @objc func openMenu() {
        
        MenuLeadingConstraint.constant = 0 //remove menu from view

        mainTintedV.isHidden = false //Shows tinted VC

        showMenu = true

        changeMenuImageOpen()
        
        UIView.animate(withDuration: 0.4, animations:{
            self.view.layoutIfNeeded()})
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
    
    //Help Direct Initial VC to differentVC (Without Navigation Controller)
    static func goTo(_ view: String, animate: Bool){
        OperationQueue.main.addOperation {
            func topMostController() -> UIViewController {
                var topController: UIViewController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.rootViewController!
                while (topController.presentedViewController != nil) {
                    topController = topController.presentedViewController!
                }
                return topController
            }
            if let second = topMostController().storyboard?.instantiateViewController(withIdentifier: view) {
                topMostController().present(second, animated: animate, completion: nil)
                // topMostController().navigationController?.pushViewController(second, animated: animate)
            }
        }
    }
}

//MARK: Products View Stuff (Collection View)
extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //return images.count //Creates no. of cells based on length of images array
        return feedItems.count //(Uncomment if using database)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Create cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductCell
        
        cell.productImage.image = images[indexPath.row] //Places image of a certain index of image array in indexPath of imageview of cell
        
        //cell.productDescription.text = name[indexPath.row] //Places text of a certain index of text array in indexPath of Label of cell (Comment if using database)
        
        //Get data of product by cell (from database)
        let item: ProductsModel = feedItems[indexPath.row] as! ProductsModel //(Uncomment if using database)
        // Get references to labels of cell
        cell.productDescription.text = item.name //(Uncomment if using database)
        
        //cell.productPrice.text = price[indexPath.row] //Comment if using database
        cell.productPrice.text = item.price //Uncomment if using database
        
        return cell
    }
    
    //Information sent to ProductVC
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.endEditing(true)
        /* If not using database, uncomment this code; hard coded variables
        ProductVC.prodPic = images[indexPath.row]
        ProductVC.prodName = name[indexPath.row]
        ProductVC.prodPrice = price[indexPath.row]
        ProductVC.prodBrand = brand[indexPath.row]
        ProductVC.prodStyle = style[indexPath.row]
        ProductVC.prodColorway = colorway[indexPath.row]
        ProductVC.prodRelease = release[indexPath.row]
        ProductVC.prodRetail = retail[indexPath.row]
 */
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
        
        navGoTo("ProductVC", animate: true)
    }
}

// (Uncomment if using database)
//MARK: Database Stuff
extension MainVC: HomeModelProtocol {
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.collectionView.reloadData()
    }
}

//MARK: Menu View Stuff (Table View)
extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = menuOptions[indexPath.row]
        
        cell.textLabel?.font = UIFont(name: "Avenir-Book", size: 18)
        
        //cell.textLabel?.textAlignment = .center //centres text label in table view
        
        cell.imageView?.image = menuImages[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch menuOptions[indexPath.row] {
        case "Settings":
            print("Settings pressed")
        case "Rate Us":
            print("Rate Us pressed")
        case "Sign Out":
            MainVC.goTo("LoginVC", animate: true)
            print("Sign Out pressed")
        default:
            print("Nada")
        }
    }
    
}
