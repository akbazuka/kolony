//
//  SignUpVC.swift
//  Kolony
//
//  Created by Kedlaya on 3/4/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var confirmPassText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var haveAccBtn: UIButton!
    
    let loginVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true

        passText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confirmPassText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
//        haveAccBtn.layer.cornerRadius = 5
//        haveAccBtn.layer.borderWidth = 1
//        haveAccBtn.layer.borderColor = UIColor.black.cgColor
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //Resets fields and activity indicator
        emailText.text = ""
        passText.text = ""
        confirmPassText.text = ""
        usernameText.text = ""
        activityIndicator.isHidden = true
    }
    
    @IBAction func backBtnOnClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let passTxt = passText.text else { return }
        
        // If we have started typing in the confirm pass text field.
        if textField == confirmPassText {
            //When the passwords match, the text fields border color turn green.
            if passTxt == confirmPassText.text {

                passText.layer.borderWidth = 1
                passText.layer.cornerRadius = 5
                passText.layer.borderColor = UIColor(hue: 0.3639, saturation: 0.69, brightness: 0.94, alpha: 1.0).cgColor /* #4aef68: Green */

                confirmPassText.layer.borderWidth = 1
                confirmPassText.layer.cornerRadius = 5
                confirmPassText.layer.borderColor = UIColor(hue: 0.3639, saturation: 0.69, brightness: 0.94, alpha: 1.0).cgColor /* #4aef68: Green */
            } else {

                passText.layer.borderColor = UIColor(hue: 0.0167, saturation: 0.73, brightness: 1, alpha: 1.0) /* #ff5743 */.cgColor

                confirmPassText.layer.borderColor = UIColor(hue: 0.0167, saturation: 0.73, brightness: 1, alpha: 1.0) /* #ff5743 */.cgColor
            }
        } else {
            if passTxt.isEmpty {
                passText.layer.borderColor = UIColor(red:204/255, green:204/255, blue:204/255, alpha:1.0).cgColor /* Text fireld default border color*/

                confirmPassText.layer.borderColor = UIColor(red:204/255, green:204/255, blue:204/255, alpha:1.0).cgColor /* Text fireld default border color*/
                confirmPassText.text = ""
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameText.endEditing(true)
        emailText.endEditing(true)
        passText.endEditing(true)
        confirmPassText.endEditing(true)
    }
    
    @IBAction func haveAnAccOnClick(_ sender: Any) {
        self.present(loginVC, animated: true, completion: nil)
    }
    
    @IBAction func registerBtnOnClick(_ sender: Any) {
        
        guard let email = emailText.text , !email.isEmpty ,
            let username = usernameText.text , !username.isEmpty ,
            let password = passText.text , !password.isEmpty else {
                alert(title: "Error", message: "Please fill out all fields.")
                return
        }
        
        guard let confirmPass = confirmPassText.text , confirmPass == password else {
            alert(title: "Error", message: "Passwords do not match.")
            return
        }
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        guard let authUser = Auth.auth().currentUser else { return }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        authUser.link(with: credential) { (result, error) in
        if let error = error {
            debugPrint(error)
            Auth.auth().handleFireAuthError(error: error, vc: self)
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            return
        }
            guard let firUser = result?.user else { return } //firUser is the Firebase authenticated user
            let kolonyUser = User.init(id: firUser.uid, email: email, username: username, stripeId: "")
            // Upload to Firestore
            self.createFirestoreUser(user: kolonyUser)
            
            //Set user defaults
            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set(password, forKey: "password")
        }
    }
    
    func createFirestoreUser(user: User) {
        // Step 1: Create document reference
        let newUserRef = Firestore.firestore().collection("users").document(user.id)
        
        // Step 2: Create model data
        let data = User.modelToData(user: user)
        
        // Step 3: Upload to Firestore.
        newUserRef.setData(data) { (error) in
            if let error = error {
                Auth.auth().handleFireAuthError(error: error, vc: self)
                debugPrint("Error creating account: \(error.localizedDescription)")
            } else {
                //self.dismiss(animated: true, completion: nil)
                //Go to MainVC through navigation controller
                let loginVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
                self.present(loginVC, animated: true, completion: nil)
            }
            self.activityIndicator.stopAnimating()
        }
    }
}


