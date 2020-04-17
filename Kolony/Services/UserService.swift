//
//  UserService.swift
//  Kolony
//
//  Created by Kedlaya on 3/10/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

let UserService = _UserService()

final class _UserService {
    
    // Variables
    var user = User()
    //var orders = [Order]()
    var orderProductInvent : ProductInventory!
    var orderProduct : Product!
    let auth = Auth.auth()
    let db = Firestore.firestore()
    var userListener : ListenerRegistration? = nil
    var ordersListener : ListenerRegistration? = nil
    var adminAddProductsListener : ListenerRegistration? = nil
    
    var isGuest : Bool {
        
        guard let authUser = auth.currentUser else {
            return true
        }
        if authUser.isAnonymous {
            return true
        } else {
            return false
        }
    }
    
    func getCurrentUser() {
        guard let authUser = auth.currentUser else { return }
        
        //print("Authorized user")
        
        let userRef = db.collection("users").document(authUser.uid)
        //If user changes credentials like username or email
        userListener = userRef.addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                //print("There is an error here.")
                return
            }
            
            guard let data = snap?.data() else { return }
            self.user = User.init(data: data)
            //print("Success",self.user)
        })
    }
    
    func updateUser(new: String, type: String){
        let updateUserRef = Firestore.firestore().collection("users").document(UserService.user.id)

        updateUserRef.updateData([
            //type is passed either username or email
            type : new
        ]) { err in
            if let err = err {
                print("Error updating \(type): \(err)")
            } else {
                print("Successfully updated \(type)")
            }
        }
    }
    
    //Add order to database when item sold
    func sendOrders(productInvent: ProductInventory, product: Product) {

        let inventoryRef = Firestore.firestore().collection("inventory").whereField("product", isEqualTo: product.id).whereField("sold", isEqualTo: false).order(by: "timeStamp", descending: false).limit(to: 1) // Only pull the earliest doucment in the collectoin (by timestamp)
        inventoryRef.getDocuments { (querySnapshot1, error) in
            if let error = error {
                print("Error getting inventory: \(error)")
            } else {
                let inventory = querySnapshot1!.documents[0]
                let inventoryId = inventory.get("id")
                let inventoryIdRef = Firestore.firestore().collection("inventory").document(inventoryId as! String)
                inventoryIdRef.getDocument { (doc, er) in
                    //Update inventory's sold field to true
                    inventoryIdRef.updateData([
                        "sold": true
                    ]) { er in
                        if let er = er {
                            print("Error updating sold: \(er)")
                        } else {
                            print("sold successfully updated")
                        }
                    }
                }
                
                //Send order ot database
                let ref = Firestore.firestore().collection("orders").document()
                let docId = ref.documentID
                
                ref.setData([
                    "id" : docId,
                    "user" : self.user.id,
                    "productImages" : product.images,
                    "productName" : product.name,
                    "productPrice": product.price,
                    "productSize" : productInvent.size,
                    "inventoryId" : inventoryId,
                    "productInventoryId" : productInvent.id,
                    "timeStamp" : FieldValue.serverTimestamp()
                ])
            }
        }
        
        //Reduce stock when user makes purchase
        let updateInventoryRef = Firestore.firestore().collection("productInventory").document(productInvent.id)
        
        updateInventoryRef.updateData([
            "stock": FieldValue.increment(-1.00)
        ]) { err in
            if let err = err {
                print("Error updating stock: \(err)")
            } else {
                print("Stock successfully updated")
            }
        }
        //Check if stock still exists after user makes purchase and if not, update to soldOut = true
        updateInventoryRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let productInvent1 = ProductInventory.init(data: data!)
                //Update document's soldOut field to true is no more stock left
                if productInvent1.stock == 0{
                    updateInventoryRef.updateData([
                        "soldOut": true
                    ]) { err in
                        if let err = err {
                            print("Error updating soldOut: \(err)")
                        } else {
                            print("soldOut successfully updated")
                        }
                    }
                    
                    //Keep track of whether inventory exists (other sizes for same shoe) for the product or not after user buys and size gets sold out
                    var noOfResults = 0
                    
                    Firestore.firestore().collection("productInventory").whereField("product", isEqualTo: product.id).whereField("soldOut", isEqualTo: "false")
                        .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data())")
                                noOfResults += 1
                            }
                        }
                    }
                    
                    let updateProductRef = Firestore.firestore().collection("products").document(product.id)
                    //Check if product inventory still exists after user makes purchase and if not, update to inventoryExists = true
                    //Update document's inventoryExists field to false is no more stock left
            
                    if noOfResults == 0{
                        updateProductRef.updateData([
                            "inventoryExists": false
                        ]) { err in
                            if let err = err {
                                print("Error updating inventoryExists: \(err)")
                            } else {
                                print("inventoryExists successfully updated")
                            }
                        }
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func logoutUser() {
        userListener?.remove()
        userListener = nil
        user = User()
        orderProductInvent = nil
        orderProduct = nil
        LoginVC.admin = false
        
        //Reset user defaults
        UserDefaults.standard.set(nil, forKey: "email")
        UserDefaults.standard.set(nil, forKey: "password")
    }
}

