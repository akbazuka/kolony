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
    var orders = [ProductInventory]()
    let auth = Auth.auth()
    let db = Firestore.firestore()
    var userListener : ListenerRegistration? = nil
    //var favsListener : ListenerRegistration? = nil
    
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
            print("Success",self.user)
        })
        
        
        /*//To implement favourites
        let favsRef = userRef.collection("favorites")
        favsListener = favsRef.addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documents.forEach({ (document) in
                let favorite = Product.init(data: document.data())
                self.favorites.append(favorite)
            })
        })*/
    }
    
    //Add order to subcollection of user when item sold
    func sendOrders(productInventId: String) {
        let ref = Firestore.firestore().collection("orders").document()
        let docId = ref.documentID
        
        ref.setData([
            "id" : docId,
            "user" : user.id,
            "productInvetoryId" : productInventId,
            "timeStamp" : FieldValue.serverTimestamp()
        ])
        //print("Sent order")
    }

    
    func logoutUser() {
        userListener?.remove()
        userListener = nil
        //favsListener?.remove()
        //favsListener = nil
        user = User()
        //favorites.removeAll()
        
        //Reset user defaults
        UserDefaults.standard.set(nil, forKey: "email")
        UserDefaults.standard.set(nil, forKey: "password")
    }
}

