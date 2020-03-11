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
    
    //@IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var confirmPassText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passCheckImg: UIImageView!
    @IBOutlet weak var confirmPassCheckImg: UIImageView!
    
    static var dataURL = "http://localhost/kolony.php?type="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //backBtn.setTitle("Back", for: .normal)
        //.setTitleColor(UIColor.systemBlue, for: UIControl.State.highlighted)
        passText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confirmPassText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let passTxt = passText.text else { return }
        
        // If we have started typing int he confirm pass text field.
        if textField == confirmPassText {
            passCheckImg.isHidden = false
            confirmPassCheckImg.isHidden = false
        } else {
            if passTxt.isEmpty {
                passCheckImg.isHidden = true
                confirmPassCheckImg.isHidden = true
                confirmPassText.text = ""
            }
        }
        //When the passwords match, the checkmarks turn green.
        if passText.text == confirmPassText.text {
            passCheckImg.image = UIImage(named: "greenCheck")
            confirmPassCheckImg.image = UIImage(named: "greenCheck")
        } else {
            passCheckImg.image = UIImage(named: "redCheck")
            confirmPassCheckImg.image = UIImage(named: "redCheck")
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameText.endEditing(true)
        emailText.endEditing(true)
        passText.endEditing(true)
        confirmPassText.endEditing(true)
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
        
        activityIndicator.startAnimating()
        
        guard let authUser = Auth.auth().currentUser else {
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        authUser.link(with: credential) { (result, error) in
        if let error = error {
            debugPrint(error)
            self.alert( title: "Error", message: "\(error.localizedDescription )")
            return
        }
            guard let firUser = result?.user else { return }
            let artUser = User.init(id: firUser.uid, email: email, username: username, stripeId: "")
            // Upload to Firestore
            self.createFirestoreUser(user: artUser)
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
                self.alert( title: "Error", message: "\(error.localizedDescription )")
                debugPrint("Error signing in: \(error.localizedDescription)")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    //Alert Popup
    func alert(title: String, message: String) {
        
        //Error Title
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Action Title
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //Present to Screen
        present(alert,animated: true,completion: nil)
    }
}


