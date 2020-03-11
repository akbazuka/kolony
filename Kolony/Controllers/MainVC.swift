//
//  SwiftUIView.swift
//  Book Buddy
//
//  Created by Kedlaya on 1/25/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import UIKit
import Firebase

class MainVC: UIViewController{
    
    //Store userID
    static var user = ""

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

    var menuOptions = ["Settings", "Rate Us", "Sign Out"]
    
    var menuImages = [UIImage(named: "settingsPic"), UIImage(named: "ratePic"), UIImage(named: "exitPic")]
    
    var db : Firestore!
    var products = [Product]()
    var listener : ListenerRegistration!
    
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        //Change "Sign Out" button to "Login" if user enters as guest
        if (LoginVC.isGuest == 1){
            menuOptions[2] = "Login"
        }

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
        
        //Initial setup of guest user
        guestUserSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Pulls data from database
        setProductsListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()       //Removes listeners to save data in Firestore; stops real time updates
        products.removeAll()    //Delete data from Firestore cache to avoind duplicating data every time view appears
        collectionView.reloadData()
    }
    
    func guestUserSetup() {
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    Auth.auth().handleFireAuthError(error: error, vc: self)
                    debugPrint(error)
                }
            }
        }
    }
    
    //Fetch all document of a certain collection Firestore Database and Listens for Real-Time Updates
    func setProductsListener() {
        /* - Snapshot Listeners allows Real-Time Updates; assign listener variable and do something with it when view appears and is destroyed
           - .order(by: "timeStamp", descending: true) is a Firestore query that orders products by date;
                in this case, descending will order products from most recently added (newest) to first added
                (oldest).
            */
        listener = db.collection("products").order(by: "timeStamp", descending: true).addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
            }
            
            //Get all documents
            snap?.documentChanges.forEach({ (change) in //Loop through documents

                let data = change.document.data()                 //Get data after change made
                let product = Product.init(data: data)            //Each product in data array
                
                //What type pf change made to database
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, product: product)
                case .modified:
                    self.onDocumentModified(change: change, product: product)
                case .removed:
                    self.onDocumentRemoved(change: change)
                }
            })
        })
    }
    
    //When new document is added to database
    func onDocumentAdded(change: DocumentChange, product: Product){
        let newIndex = Int(change.newIndex) //Returns UInt so cast to Int
        products.insert(product, at: newIndex) //Insert into correct position of products array
        collectionView.insertItems(at: [IndexPath(item: newIndex, section: 0)]) //Insert at bottom of collectionview

    }
    
    func onDocumentModified(change: DocumentChange, product: Product){
        //Item remained at the same location (position) in the databse
        if change.newIndex == change.oldIndex {
            let index = Int(change.newIndex)
            products[index] = product //Replace new (changed) product with old
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        } else {
            
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            
            products.remove(at: oldIndex)           //Remove old product at its index
            products.insert(product, at: newIndex)  //Add new item at the index of the old item
            
            collectionView.moveItem(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
        }
        
    }
    
    //When new document is deleted from database
    func onDocumentRemoved(change: DocumentChange){
        let oldIndex = Int(change.oldIndex)
        products.remove(at: oldIndex)
        collectionView.deleteItems(at: [IndexPath(item: oldIndex, section: 0)]) //Reload collectionViewData after delete
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
        //print("We have: \(products.count)")
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Create cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductCell
        
        //cell.productImage.image = images[indexPath.row] //Places image of a certain index of image array in indexPath of imageview of cell
        
        //Get data of product by cell (from database)
        let item: Product = products[indexPath.row]
        // Get references to labels of cell
        cell.productName.text = item.name

        //Convert Price fro Double to Currency to be displayed
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: item.price as NSNumber) {
            cell.productPrice.text = price
        }
        
        return cell
    }
    
    //Information sent to ProductVC
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.endEditing(true)
        
        //Get data of product by cell (from database)
        let item: Product = products[indexPath.row]
    
        //ProductVC.prodPic = item.images //Send images here
        ProductVC.prodName = item.name
        ProductVC.prodPrice = item.price
        ProductVC.prodBrand = item.brand
        ProductVC.prodStyle = item.style
        ProductVC.prodColorway = item.colorway
        ProductVC.prodRelease = item.release
        ProductVC.prodRetail = item.retail
        ProductVC.prodID = item.id
        
        navGoTo("ProductVC", animate: true)
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
            //Sign out of Firebase account here
            //...
            
            //Navigates back to Login screen
            MainVC.goTo("LoginVC", animate: true)
            //Resets user defaults
            UserDefaults.standard.set(nil, forKey: "uID")
            //print("Sign Out pressed")
        case "Login":
            //Navigates back to Login screen
            MainVC.goTo("LoginVC", animate: true)
        default:
            print("Nada")
        }
    }
    
}
