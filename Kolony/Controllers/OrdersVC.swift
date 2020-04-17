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
    
    var orders = [Order]()
    var db : Firestore!
    var listener : ListenerRegistration!
    
    var barButtonClicked: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()  //Initialize the database
        navBarSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Pulls data from database
        setOrdersListener()
        barButtonClicked = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        listener.remove()       //Removes listeners to save data in Firestore; stops real time updates
        tableView.reloadData()
        
        if self.isMovingFromParent && barButtonClicked == false{
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers
            for vc in viewControllers {
                if vc is MainVC {
                    self.navigationController!.popToViewController(vc, animated: true)
                    return
                }
            }
        }
    }
    
    func navBarSetup(){
        //self.navigationController?.navigationItem.title = "My Orders"
        self.title = "My Orders"
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setOrdersListener() {
        //Snapshot listener of orders for current user
        listener = db.orders(userId: UserService.user.id).addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
            }
            
            //Get all documents
            snap?.documentChanges.forEach({ (change) in //Loop through documents

                let data = change.document.data()             //Get data after change made
                let order = Order.init(data: data)            //Each product in data array

                //What type pf change made to database
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, order: order)
                case .modified:
                    self.onDocumentModified(change: change, order: order)
                case .removed:
                    self.onDocumentRemoved(change: change)
                }
            })
        })
    }
    
    @IBAction func homeBtnOnClick(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for vc in viewControllers {
            if vc is MainVC {
                self.navigationController!.popToViewController(vc, animated: true)
            }
        }
        barButtonClicked = true
    }
    
    @IBAction func cartBtnOnClick(_ sender: Any) {
       let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for vc in viewControllers {
            if vc is CheckoutVC {
                self.navigationController!.popToViewController(vc, animated: true)
                return
            }
        }
        let checkoutVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CheckoutVC")
        self.navigationController?.pushViewController(checkoutVC, animated: true)
        barButtonClicked = true
    }
    
    @IBAction func accBtnOnClick(_ sender: Any) {
        //Pop VC if already exists in navigation stack
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for vc in viewControllers {
            if vc is AccountVC {
                self.navigationController!.popToViewController(vc, animated: true)
                return
            }
        }
        //If VC does not exist in Navigation stack, psuh to VC
        let accountVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountVC")
        self.navigationController?.pushViewController(accountVC, animated: true)
        barButtonClicked = true
    }
}

//MARK: TableView
extension OrdersVC: UITableViewDelegate, UITableViewDataSource {
    
    //When new document is added to database
    func onDocumentAdded(change: DocumentChange, order: Order){
        let newIndex = Int(change.newIndex) //Returns UInt so cast to Int
        orders.insert(order, at: newIndex) //Insert into correct position of products array
        //tableView.insertRows(at: [IndexPath(item: newIndex, section: 0)], with: .automatic) //Insert at bottom of collectionview; Does not work?
        tableView.reloadData()
    }
    //When a document is changed in the database
    func onDocumentModified(change: DocumentChange, order: Order){
        //Item remained at the same location (position) in the databse
        if change.newIndex == change.oldIndex {
            let index = Int(change.newIndex)
            orders[index] = order //Replace new (changed) product with old
            //tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
            tableView.reloadData()
        } else {
            
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            
            orders.remove(at: oldIndex)           //Remove old product at its index
            orders.insert(order, at: newIndex)  //Add new item at the index of the old item
            
            //tableView.moveRow(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
            tableView.reloadData()
        }
    }
    
    //When new document is deleted from database
    func onDocumentRemoved(change: DocumentChange){
        let oldIndex = Int(change.oldIndex)
        orders.remove(at: oldIndex)
        
        //tableView.deleteRows(at: [IndexPath(item: oldIndex, section: 0)], with: .automatic)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as? OrderCell {
            
            cell.configureCell(order: orders[indexPath.row])
            
            return cell
        }
        
        return UITableViewCell()
    }
}

