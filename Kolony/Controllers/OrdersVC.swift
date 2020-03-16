//
//  OrdersVC.swift
//  Kolony
//
//  Created by Kedlaya on 3/15/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class OrdersVC: UIViewController/*, OrderCellDelegate */{
    
    @IBOutlet weak var tableView: UITableView!
    
    var orders = [ProductInventory]()
    var products = [Product]()
    var db : Firestore!
    var listener : ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blockGuestUser()
        db = Firestore.firestore()  //Initialize the database
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Pulls data from database
        setOrdersListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()       //Removes listeners to save data in Firestore; stops real time updates
        tableView.reloadData()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //Don't allow guest user to visit CheckoutVC
    func blockGuestUser(){
        if UserService.isGuest == true{
            let alertController = UIAlertController(title: "Hi friend!", message: "This is a user only feature. Please create an account with us to be able to access all of our features.", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                self.navigationController?.popViewController(animated: true) //Dismiss VC
            }
            
            let signup = UIAlertAction(title: "Sign-Up", style: .default) { (action) in
                //Navigate to SignUpVC
                let signUpVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC")
                self.present(signUpVC, animated: true, completion: nil)
            }
            
            alertController.addAction(cancel)
            alertController.addAction(signup)
            present(alertController,animated: true,completion: nil)
        }
    }
    
    func setOrdersListener() {
        /* - Snapshot Listeners allows Real-Time Updates; assign listener variable and do something with it when view appears and is destroyed
           - .order(by: "timeStamp", descending: true) is a Firestore query that orders products by date;
                in this case, descending will order products from most recently added (newest) to first added
                (oldest).
            */
        listener = db.pr.addSnapshotListener({ (snap, error) in
            
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
}

//MARK: TableView
extension OrdersVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StripeCart.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as? CartCell {
            
            cell.configureCell(productInventory: StripeCart.cartItems[indexPath.row], product: StripeCart.cartProducts[indexPath.row], delegate: self)
            
            return cell
        }
        
        return UITableViewCell()
    }
}
}
