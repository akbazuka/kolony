//
//  SwiftUIView.swift
//  Book Buddy
//
//  Created by Kedlaya on 1/25/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class MainVC: UIViewController{

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var MenuLeadingConstraint: NSLayoutConstraint!

    @IBOutlet weak var menuButton: UIButton!

    @IBOutlet weak var mainTintedV: UIView!
    
    @IBOutlet weak var menuView: UITableView!

    @IBOutlet var mainView: UIView!
    
    var callCount = 1
    
    var showMenu = false
    
    var tapGesture = UITapGestureRecognizer()
    
    var swipeLeft = UISwipeGestureRecognizer()
    
    var screenEdgeRecognizer: UIScreenEdgePanGestureRecognizer!

    let attributes = [NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 24)!] //For changing font of navigation bar title

    var menuOptions = ["Settings", "Rate Us", "My Orders","Logout"]
    
    var menuImages = [UIImage(named: "settingsPerson24pt"), UIImage(named: "ratePic"), UIImage(named: "receiptPic_24pt"), UIImage(named: "exitPic")]
    
    var db : Firestore!
    var products = [Product]()
    var listener : ListenerRegistration!
    var filteredProducts = [Product]()
    var searchActive = false
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()  //Initialize the database
        interactionWithMenu()       //Sets up menu and allows intuitive interaction
        UINavigationBar.appearance().titleTextAttributes = attributes //Changes font of navigation bar title
        
        //searchControllerConfig()
        guestUserSetup()            //Initial setup of guest user
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Pulls data from database
        setProductsListener()
        getUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchControllerConfig() //Reset search controller before MainVC appears
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()       //Removes listeners to save data in Firestore; stops real time updates
        products.removeAll()    //Delete data from Firestore cache to avoind duplicating data every time view appears
        filteredProducts.removeAll()
        collectionView.reloadData()
        searchActive = false
        //Remove search bar; only way to make scope bar diappear when leave MainVC and hit back button
        navigationItem.searchController = nil
    }
    
    func searchControllerConfig() {
        navigationItem.searchController = searchController
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Kolony"
        searchController.searchBar.sizeToFit()
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.returnKeyType = .search
        searchController.searchBar.scopeButtonTitles = ["Name","Brand","Color","Style"]
        
        searchController.searchBar.becomeFirstResponder()
        
        self.searchController.searchBar.becomeFirstResponder()

        
        ////Add search bar in the navigation bar
        //self.navigationItem.titleView = searchController.searchBar
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
    
    func guestExperience() {
        if UserService.isGuest == true{
            menuOptions.remove(at: 2) //Remove "My Oders" from menu if user is guest
            menuImages.remove(at: 2)
            menuOptions[2] = "Login"  //Change Logout button to Login if user is guest
        }
    }
    
    func getUser(){
        if let user = Auth.auth().currentUser , !user.isAnonymous {
            // We are logged in
            if UserService.userListener == nil {
                UserService.getCurrentUser() //Get current user information
            }
        }
    }
    
    func interactionWithMenu() {
        MenuLeadingConstraint.constant = -218 //Presents (default) menu bar to hide
        
        mainTintedV.isHidden = true //Hides tinted VC by default
        
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
    }
    
    //Fetch all documents of a certain collection Firestore Database and Listens for Real-Time Updates
    func setProductsListener() {
        /* - Snapshot Listeners allows Real-Time Updates; assign listener variable and do something with it when view appears and is destroyed
           - .order(by: "timeStamp", descending: true) is a Firestore query that orders products by date;
                in this case, descending will order products from most recently added (newest) to first added
                (oldest).
            */
        listener = db.products.addSnapshotListener({ (snap, error) in
            
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
    
    //Menu opens and closes as hamburger button is pressed
    @IBAction func menuButtonPressed(_ sender: Any) {

    if (showMenu){ //When menu is visible
            closeMenu()
        }
        else { //When menu is not visible
            openMenu()
        }
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
    
//    //Navigate to different VC manually (With Navigation Controller)
//    func navGoTo(_ view: String, animate: Bool){
//        OperationQueue.main.addOperation {
//            func topMostController() -> UIViewController {
//                var topController: UIViewController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.rootViewController!
//                while (topController.presentedViewController != nil) {
//                    topController = topController.presentedViewController!
//                }
//                return topController
//            }
//            if let second = topMostController().storyboard?.instantiateViewController(withIdentifier: view) {
//                self.navigationController?.pushViewController(second, animated: animate)
//            }
//        }
//    }
    
//    //Help Direct Initial VC to differentVC (Without Navigation Controller)
//    static func goTo(_ view: String, animate: Bool){
//        OperationQueue.main.addOperation {
//            func topMostController() -> UIViewController {
//                var topController: UIViewController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.rootViewController!
//                while (topController.presentedViewController != nil) {
//                    topController = topController.presentedViewController!
//                }
//                return topController
//            }
//            if let second = topMostController().storyboard?.instantiateViewController(withIdentifier: view) {
//                topMostController().present(second, animated: animate, completion: nil)
//                //topMostController().navigationController?.pushViewController(second, animated: animate)
//            }
//        }
//    }
    
    func searchFilterName(searchBar: UISearchBar){
        //let searchText = searchController.searchBar.text?.lowercased()
        let searchText = searchBar.text?.lowercased()

        if searchText!.isEmpty == false {
            //Search according to product name
            filteredProducts = products.filter { product -> Bool in
                return product.name.lowercased().lowercased().contains(searchText!)
            }
        } else {

            filteredProducts = products
        }

        collectionView.reloadData()
    }

    func searchFilterBrand(searchBar: UISearchBar){
        //let searchText = searchController.searchBar.text?.lowercased()
        let searchText = searchBar.text?.lowercased()

        if searchText!.isEmpty == false {
            //Search according to product brand
            filteredProducts = products.filter { product -> Bool in
                return product.brand.lowercased().contains(searchText!)
            }
        } else {

            filteredProducts = products
        }

        collectionView.reloadData()
    }

    func searchFilterColor(searchBar: UISearchBar){
        //let searchText = searchController.searchBar.text?.lowercased()
        let searchText = searchBar.text?.lowercased()

        if searchText!.isEmpty == false {
            //Search according to color
            filteredProducts = products.filter { product -> Bool in
                return product.colorway.lowercased().contains(searchText!) //Add another field that has string as colours that deines raw colors of a product; i.e. black, red, yellow, blue, etc.
            }
        } else {

            filteredProducts = products
        }

        collectionView.reloadData()
    }

    func searchFilterStyle(searchBar: UISearchBar){
        //let searchText = searchController.searchBar.text?.lowercased()
        let searchText = searchBar.text?.lowercased()

        if searchText!.isEmpty == false {
            //Search according to color
            filteredProducts = products.filter { product -> Bool in
                return product.style.lowercased().contains(searchText!)
            }
        } else {

            filteredProducts = products
        }

        collectionView.reloadData()
    }
}

//MARK: Products View Stuff (Collection View)
extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //When new document is added to database
    func onDocumentAdded(change: DocumentChange, product: Product){
        let newIndex = Int(change.newIndex) //Returns UInt so cast to Int
        products.insert(product, at: newIndex) //Insert into correct position of products array
        collectionView.insertItems(at: [IndexPath(item: newIndex, section: 0)]) //Insert at bottom of collectionview

    }
    //When a document is changed in the database
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
    
    //Resize collection view accroding to phone size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.size.height
        let width = view.frame.size.width
        return CGSize(width: width * 0.45, height: height * 0.35)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive{
            return filteredProducts.count
        } else {
            return products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Create cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductCell
        
        let item: Product

        //If user searches
        if searchActive{
            item = filteredProducts[indexPath.row]
        } else {
            //Get data of product by cell (from database)
            item = products[indexPath.row]
        }
        
        //Pulls image from URL that was given as a String and displays in image view
        if let imageURL = URL(string: item.images){
            cell.productImage.kf.indicatorType = .activity
            cell.productImage.kf.setImage(with: imageURL)
        }
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
        //searchBar.endEditing(true)
        
        let item: Product

        //If user searches
        if searchActive{
            item = filteredProducts[indexPath.row]
        } else {
            //Get data of product by cell (from database)
            item = products[indexPath.row]
        }
        
        ProductVC.product = item
        
        let productVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductVC")
        
        self.navigationController?.pushViewController(productVC, animated: true)
    }
    
    //Change color of cell when user taps on it
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        }
    }
    //Change color of cell back when user lifts finger off of screen
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.white
        }
    }
}

//MARK: Menu View Stuff (Table View)
extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.callCount == 1{
            guestExperience()
            self.callCount -= 1
        }
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = menuOptions[indexPath.row]
        
        cell.textLabel?.font = UIFont(name: "Avenir-Book", size: 18)
        
        cell.imageView?.image = menuImages[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch menuOptions[indexPath.row] {
        case "Settings":
            let accountVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountVC")
            self.navigationController?.pushViewController(accountVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
            self.closeMenu()
            
        case "Rate Us":
            print("Rate Us pressed")
            tableView.deselectRow(at: indexPath, animated: true)
            self.closeMenu()
            
        case "My Orders":
            let ordersVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrdersVC")
            self.navigationController?.pushViewController(ordersVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
            self.closeMenu()
            
        default: //For login and logout cases(combined to one)
            guard let user = Auth.auth().currentUser else { return }
            
            if user.isAnonymous {
                tableView.deselectRow(at: indexPath, animated: true)
                self.closeMenu()
                //self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            } else {
                do {
                    try Auth.auth().signOut()
                    UserService.logoutUser()
                    Auth.auth().signInAnonymously { (result, error) in
                        if let error = error {
                            Auth.auth().handleFireAuthError(error: error, vc: self)
                            debugPrint(error)
                        }
                        tableView.deselectRow(at: indexPath, animated: true)
                        self.closeMenu()
                        //self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: true, completion: nil)
                    }
                } catch {
                    Auth.auth().handleFireAuthError(error: error, vc: self)
                    debugPrint(error)
                }
            }
        }
    }    
}

//MARK: Search Bar Stuff
extension MainVC: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating{
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchController.searchBar.text = ""
         //self.dismiss(animated: true, completion: nil)
     }
     
     func updateSearchResults(for searchController: UISearchController)
     {
        let scopeString = searchController.searchBar.selectedScopeButtonIndex
                switch scopeString{
                case 0:
                    searchFilterName(searchBar: searchController.searchBar)
                case 1:
                    searchFilterBrand(searchBar: searchController.searchBar)
                case 2:
                    searchFilterColor(searchBar: searchController.searchBar)
                case 3:
                    searchFilterStyle(searchBar: searchController.searchBar)
                default:
                    return
        }
    }

     func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        collectionView.reloadData()
     }
     
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //collectionView.reloadData()
        searchActive = false
     }
}
