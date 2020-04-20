//
//  AddProductVC.swift
//  Kolony
//
//  Created by Kedlaya on 3/22/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import FirebaseStorage
import FirebaseFirestore

class AddProductVC: UIViewController{
    
    //Outlets
    @IBOutlet weak var productImages: UIImageView!
    @IBOutlet weak var productNameTxt: UITextField!
    @IBOutlet weak var productBrandTxt: UITextField!
    @IBOutlet weak var productPriceTxt: UITextField!
    @IBOutlet weak var retailPriceTxt: UITextField!
    @IBOutlet weak var styleTxt: UITextField!
    @IBOutlet weak var colorwayTxt: UITextField!
    @IBOutlet weak var releaseTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Eventually change to front, back, left side and right side images
    var imagePlaceholders = [UIImage(named: "cameraPic"), UIImage(named: "cameraPic"), UIImage(named: "cameraPic"),  UIImage(named: "cameraPic")]
    var images = [UIImage(named: "cameraPic"), UIImage(named: "cameraPic"), UIImage(named: "cameraPic"),  UIImage(named: "cameraPic")]
    var isPlaceholder = [true, true, true, true]
    var currentImage = 0 //For swiping images
    var selectedDate: Date!
    
    private var datePicker: UIDatePicker?
    
    var allImagesAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpGestures()
        initializeDatePicker()
    }
    
    func initializeDatePicker(){
        datePicker = UIDatePicker()
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        releaseTxt.inputView = datePicker
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true) //Force dismissal of any open view (mainly for datpicker)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        
        selectedDate = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        releaseTxt.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true) //Force dismissal of datepicker
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
    
    @IBAction func addImageOnClick(_ sender: Any) {
        launchImagePicker()
    }
    
    @IBAction func removeImageOnClick(_ sender: Any) {
        images[currentImage] = imagePlaceholders[currentImage]
        productImages.image = images[currentImage]  //Sets current image in image view back to placeholder
        isPlaceholder[currentImage] = true
    }
    
    @IBAction func addProductOnClick(_ sender: Any) {
        activityIndicator.startAnimating()
        
        for i in (0..<3){
            if isPlaceholder[i] == true{
                allImagesAdded = false
            } else {
                allImagesAdded = true
            }
        }
        
        //If all fields are filled out
        if allImagesAdded == true, productNameTxt.text != "", productBrandTxt.text != "", productPriceTxt.text != "", retailPriceTxt.text != "", styleTxt.text != "", colorwayTxt.text != "", selectedDate != nil{
            
            //Turn images to data
            guard let imageData = images[0]?.jpegData(compressionQuality: 0.2) else {return}
            guard let imageData2 = images[1]?.jpegData(compressionQuality: 0.2) else {return}
            guard let imageData3 = images[2]?.jpegData(compressionQuality: 0.2) else {return}
            guard let imageData4 = images[3]?.jpegData(compressionQuality: 0.2) else {return}
            
            //Create a storage image reference
            let imageRef = Storage.storage().reference().child("\(productNameTxt.text!).jpg")
            let imageRef2 = Storage.storage().reference().child("\(productNameTxt.text!)2.jpg")
            let imageRef3 = Storage.storage().reference().child("\(productNameTxt.text!)3.jpg")
            let imageRef4 = Storage.storage().reference().child("\(productNameTxt.text!)4.jpg")
            
            //Set metadata
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            imageRef.putData(imageData, metadata: metadata) { (metaData, error) in
                if let error = error{
                    debugPrint(error.localizedDescription)
                    self.alert(title: "Error", message: "Unable to upload image1")
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                //Once image uploaded, retrieve downloaded URL
                imageRef.downloadURL(completion: { (url, error) in
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        self.alert(title: "Error", message: "Unable to retrieve url1")
                        self.activityIndicator.stopAnimating()
                        return
                    }
                    
                    guard let url = url else {return}
                    
                    imageRef2.putData(imageData2, metadata: metadata) { (metaData, error) in
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        self.alert(title: "Error", message: "Unable to upload image2")
                        self.activityIndicator.stopAnimating()
                        return
                    }
                    
                    //Once image uploaded, retrieve downloaded URL
                    imageRef2.downloadURL(completion: { (url2, error) in
                        if let error = error{
                            debugPrint(error.localizedDescription)
                            self.alert(title: "Error", message: "Unable to retrieve url2")
                            self.activityIndicator.stopAnimating()
                            return
                        }
                        
                        guard let url2 = url2 else {return}
                        
                        imageRef3.putData(imageData3, metadata: metadata) { (metaData, error) in
                        if let error = error{
                            debugPrint(error.localizedDescription)
                            self.alert(title: "Error", message: "Unable to upload image3")
                            self.activityIndicator.stopAnimating()
                            return
                        }
                        
                        //Once image uploaded, retrieve downloaded URL
                        imageRef3.downloadURL(completion: { (url3, error) in
                            if let error = error{
                                debugPrint(error.localizedDescription)
                                self.alert(title: "Error", message: "Unable to retrieve url3")
                                self.activityIndicator.stopAnimating()
                                return
                            }
                            
                            guard let url3 = url3 else {return}
                            
                            imageRef4.putData(imageData4, metadata: metadata) { (metaData, error) in
                            if let error = error{
                                debugPrint(error.localizedDescription)
                                self.alert(title: "Error", message: "Unable to upload image4")
                                self.activityIndicator.stopAnimating()
                                return
                            }
                            
                            //Once image uploaded, retrieve downloaded URL
                            imageRef4.downloadURL(completion: { (url4, error) in
                                if let error = error{
                                    debugPrint(error.localizedDescription)
                                    self.alert(title: "Error", message: "Unable to retrieve url4")
                                    self.activityIndicator.stopAnimating()
                                    return
                                }
                                
                                guard let url4 = url4 else {return}
                                
                                //Upload product to Firestore database
                                self.addProduct(url: url.absoluteString, url2: url2.absoluteString, url3: url3.absoluteString, url4: url4.absoluteString)
                                
                            })
                            }
                        })
                        }
                    })
                    }
                })
            }
        } else {
            self.activityIndicator.stopAnimating()
           //Show alert; Pleae fill in all fields
            self.alert(title: "Please fill out all fields", message: "Pleas fill out all fields and add all images (swipe through images to see if any are missing).")
        }
    }
    
    func addProduct(url: String, url2: String, url3: String, url4: String){
        var docRef: DocumentReference!
        
        var product = Product.init(id: "", name: productNameTxt.text!, images: url, image2: url2, image3: url3, image4: url4, price: Double(productPriceTxt.text!)!, brand: productBrandTxt.text!, colorway: colorwayTxt.text!, retail: Double(retailPriceTxt.text!)!, style: styleTxt.text!, release: Timestamp(date: selectedDate), timeStamp: Timestamp())
        
        docRef = Firestore.firestore().collection("products").document()
        product.id = docRef.documentID
        
        let data = Product.modelToData(product: product)
        docRef.setData(data, merge: true) { (error) in
            if let error = error{
                debugPrint(error.localizedDescription)
                self.alert(title: "Error", message: "Unable to upload document")
                self.activityIndicator.stopAnimating()
                return
            }
            self.activityIndicator.stopAnimating()
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension AddProductVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate/*Used internally by the SDK for ImagePicker*/{
    
    func launchImagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {return}  //Original uncropped image
        productImages.contentMode = .scaleAspectFit
        images[currentImage] = image
        productImages.image = images[currentImage]  //Sets current image in image view after added from gallery
        isPlaceholder[currentImage] = false
        self.dismiss(animated: true, completion: nil)
    }
}
