//
//  ProductView.swift
//  Kolony
//
//  Created by Kedlaya on 2/1/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Kingfisher

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
    @IBOutlet weak var collectionView: UICollectionView!    //That displays sizes
    
    let attributes = [NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 10)!] //For changing font of navigation bar title
    
    //Variables
    var db: Firestore!
    var productInventory = [ProductInventory]()
    static var product: Product!
    var selectedItem : ProductInventory!
    var listener : ListenerRegistration!
    //For downloading and storing images from Kingfisher
    var images = [UIImage]()
    var currentImage = 0 //For swiping images
    var highlightedItem: IndexPath!
    
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()  //Initialize the database
        intuitiveDataVariables() //Fit data in UI fields no matter the size
        
        //Changes back button title in navigation controller to "Back"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        setData()           //Display data sent over by MainVC
        //To swipe images
        downloadImages()
        setUpGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //print("Aloha: \(ProductVC.prodID)")
        setProductsInventoryListener()  //Pulls data from database
        //print("Count 1: \(productInventory.count)")
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()               //Removes listeners to save data in Firestore; stops real time updates
        productInventory.removeAll()    //Delete data from Firestore cache to avoind duplicating data every time view appears
        collectionView.reloadData()
        selectedItem = nil
        highlightedItem = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //Manually clear cache every time user leaves ProductVC
        ImageCache.default.clearMemoryCache()
    }
    
    func setUpGestures(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(imageSwipe))
        swipeRight.cancelsTouchesInView = false
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        productImages.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(imageSwipe))
        swipeLeft.cancelsTouchesInView = false
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        productImages.addGestureRecognizer(swipeLeft)
    }
    
    func downloadImages(){
        if let imageURL = URL(string: ProductVC.product.images), let imageURL2 = URL(string: ProductVC.product.image2), let imageURL3 = URL(string: ProductVC.product.image3), let imageURL4 = URL(string: ProductVC.product.image4){
        
            KingfisherManager.shared.retrieveImage(with: imageURL){ result in
                // `result` is either a `.success(RetrieveImageResult)` or a `.failure(KingfisherError)`
                switch result {
                case .success(let value):
                    // The image was set to image view:
                    print(value.image)
                    self.images.append(value.image)

                case .failure(let error):
                    print("Error download \(imageURL) image")
                    print(error)
                }
            }
            
            KingfisherManager.shared.retrieveImage(with: imageURL2){ result in
                // `result` is either a `.success(RetrieveImageResult)` or a `.failure(KingfisherError)`
                switch result {
                case .success(let value):
                    // The image was set to image view:
                    print(value.image)
                    self.images.append(value.image)

                case .failure(let error):
                    print("Error download \(imageURL2) image")
                    print(error)
                }
            }
            
            KingfisherManager.shared.retrieveImage(with: imageURL3){ result in
                //`result` is either a `.success(RetrieveImageResult)` or a `.failure(KingfisherError)`
                switch result {
                case .success(let value):
                    // The image was set to image view:
                    print(value.image)
                    self.images.append(value.image)

                case .failure(let error):
                    print("Error download \(imageURL3) image")
                    print(error)
                }
            }
            
            KingfisherManager.shared.retrieveImage(with: imageURL4){ result in
                //`result` is either a `.success(RetrieveImageResult)` or a `.failure(KingfisherError)`
                switch result {
                case .success(let value):
                    // The image was set to image view:
                    print(value.image)
                    self.images.append(value.image)

                case .failure(let error):
                    print("Error download \(imageURL4) image")
                    print(error)
                }
            }
        }
    }
    
    @objc func imageSwipe(gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizer.Direction.left:
                if currentImage == images.count - 1 {
                    currentImage = 0
                }else{
                    currentImage += 1
                }
                productImages.image = images[currentImage]
            case UISwipeGestureRecognizer.Direction.right:
                if currentImage == 0 {
                    currentImage = images.count - 1
                }else{
                    currentImage -= 1
                }
                productImages.image = images[currentImage]
            default:
                break
            }
        }
    }
    
    func intuitiveDataVariables() {
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
        
        productImages.isUserInteractionEnabled = true
    }
    
    func setData() {
        //Sets product info according to what product was clicked on in collection view of MainVC
        if let imageURL = URL(string: ProductVC.product.images){
            productImages.kf.indicatorType = .activity
            productImages.kf.setImage(with: imageURL)
        }
        productName.text = ProductVC.product.name
        
        //Convert Price fro Double to Currency to be displayed
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: ProductVC.product.price as NSNumber) {
            productPrice.text = price
        }
        brandLabel.text = ProductVC.product.brand.uppercased()
        styleLabel.text = ProductVC.product.style.uppercased()
        colorwayLabel.text = ProductVC.product.colorway.uppercased()
        
        //Convert Firebase Timestamp() to Date() to String and set it release label's text
        let theFormatter = DateFormatter()
        theFormatter.dateStyle = .medium
        let theDate = theFormatter.string(from: ProductVC.product.release.dateValue())
        releaseLabel.text = theDate
        
        //Convert Retail from Int to Currency to be displayed
        formatter.numberStyle = .currency
        if let retail = formatter.string(from: ProductVC.product.retail as NSNumber) {
            retailLabel.text = retail
        }
    }
    
    //Fetch all documents of a certain product in Firestore Database and Listens for Real-Time Updates
    func setProductsInventoryListener() {
        listener = db.productInventory(product: ProductVC.product.id).addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
            }
            
            //Get all documents
            snap?.documentChanges.forEach({ (change) in //Loop through documents

                let data = change.document.data()                 //Get data after change made
                let inventory = ProductInventory.init(data: data) //Each product in data array
                
                //What type pf change made to database
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, inventory: inventory)
                case .modified:
                    self.onDocumentModified(change: change, inventory: inventory)
                case .removed:
                    self.onDocumentRemoved(change: change)
                }
            })
        })
    }

    @IBAction func addToCartOnClick(_ sender: Any) {
        
        //Only allows to add to cart if user is logged in with a valid account and not as guest user and size is picked
        guard let user = Auth.auth().currentUser else { return }
        
        if !user.isAnonymous, selectedItem != nil{
            //Add item to cart
            StripeCart.addItemToCart(item:selectedItem, product: ProductVC.product)
            
            //Refresh Size picker so that when user navigates back, they cannot re-add to cart
            self.selectedItem = nil
            collectionView(collectionView, didUnhighlightItemAt: highlightedItem)
            
            //Show alert saying item was added to cart
            alertNavToVC(title: "Added to Cart", message: "This item was successfully added to your shopping cart!",toVC: "CheckoutVC")
            
        } else if (user.isAnonymous) {
            alertToVC(title: "Hi friend!", message: "This is a user only feature. Please create an account with us to be able to access all of our features.", toVC: "SignUpVC")
        } else {
                alert(title: "Please select a Size", message: "Select a size for the product you wish to add to your cart.")
        }
    }
    
    @IBAction func tryOnClicked(_ sender: Any) {
        //
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
    
    //Navigate to VC after Alert (to Navigation Controller)
    func alertNavToVC(title:String, message: String, toVC: String) {
        //Error Title
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Action Title
        //alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { UIAlertAction in
            //Go to view controller through naigation controller
            let navToVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: toVC)
            self.navigationController?.pushViewController(navToVC, animated: true)
        })
        //Present to Screen
        present(alert,animated: true, completion: nil)
    }
    
    //Navigate to VC after Alert (without navigation controller)
    func alertToVC(title:String, message: String, toVC: String) {
        //Error Title
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Action Title
        //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Sign-Up", style: .default){UIAlertAction in let
            //Present VC modally
            goToVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: toVC)
        self.present(goToVC, animated: true, completion: nil)})
        
        //Present to Screen
        present(alert,animated: true, completion: nil)
    }
}

//MARK: Products View Stuff (Collection View)
extension ProductVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //When new document is added to database
    func onDocumentAdded(change: DocumentChange, inventory: ProductInventory){
        let newIndex = Int(change.newIndex) //Returns UInt so cast to Int
        productInventory.insert(inventory, at: newIndex) //Insert into correct position of products array
        collectionView.reloadData()
    }
    //When a document is changed in the database
    func onDocumentModified(change: DocumentChange, inventory: ProductInventory){
        //Item remained at the same location (position) in the databse
        if change.newIndex == change.oldIndex {
            let index = Int(change.newIndex)
            productInventory[index] = inventory //Replace new (changed) product with old
            print("New added: \(productInventory.count)")
            collectionView.reloadData()
        } else {
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            
            productInventory.remove(at: oldIndex)               //Remove old product at its index
            productInventory.insert(inventory, at: newIndex)    //Add new item at the index of the old item
            
            collectionView.reloadData()
        }
    }
    
    //When new document is deleted from database
    func onDocumentRemoved(change: DocumentChange){
        let oldIndex = Int(change.oldIndex)
        productInventory.remove(at: oldIndex)
        collectionView.reloadData()
    }
    
//    //Resize collection view accroding to phone size
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let height = view.frame.size.height
//        let width = view.frame.size.width
//        return CGSize(width: width * 0.45, height: height * 0.35)
//    }
//
//    //To center cells in collection view
//    func centerItemsInCollectionView(cellWidth: Double, numberOfItems: Double, spaceBetweenCell: Double, collectionView: UICollectionView) -> UIEdgeInsets {
//        let totalCellWidth = cellWidth * numberOfItems
//        let totalSpacingWidth = spaceBetweenCell * (numberOfItems - 1)
//
//        let leftInset = (view.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
//        let rightInset = leftInset
//
//        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("Aloha \(productInventory.count)")
        return productInventory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Create cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeCell", for: indexPath) as! SizeCell
        
        let item = productInventory[indexPath.row]
        
        //Get item's size
        cell.sizeLabel.text = NSNumber(value: item.size).stringValue
        
        return cell
    }
    
    //Prepare to add selected item to cart
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("Aloha")
        let item = productInventory[indexPath.row]
        self.selectedItem = item
        //print("Selected size is: \(selectedItem)")
        //The cell that is currently highlighted so that can be deselected later
        self.highlightedItem = indexPath
    }
    
    //Change color of cell when user taps on it
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        //Unhighlight previous item if there was a previous item selected
        if self.highlightedItem != nil {
            if let previousCell = collectionView.cellForItem(at: self.highlightedItem){
                previousCell.contentView.backgroundColor = UIColor.white
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        //Where elements_count is the count of all your items in that
        //Collection view...
        let cellCount = CGFloat(productInventory.count)

        //If the cell count is zero, there is no point in calculating anything.
        if cellCount > 0 {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing

            //20.00 was just extra spacing I wanted to add to my cell.
            let totalCellWidth = cellWidth*cellCount + 0.00 * (cellCount-1)
            let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right

            if (totalCellWidth < contentWidth) {
                //If the number of cells that exists take up less room than the
                //collection view width... then there is an actual point to centering them.

                //Calculate the right amount of padding to center the cells.
                let padding = (contentWidth - totalCellWidth) / 2.0
                return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
            } else {
                //Pretty much if the number of cells that exist take up
                //more room than the actual collectionView width, there is no
                // point in trying to center them. So we leave the default behavior.
                return UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
            }
        }
        return UIEdgeInsets.zero
    }
}

