//
//  ViewController.swift
//  Book Buddy
//
//  Created by Kedlaya on 1/20/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var signAsGusetBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //static var UID = String?
    static var isGuest = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerButton.layer.cornerRadius = 5
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.black.cgColor
        
//        registerButton.titleEdgeInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1);
        
        //registerButton.frame = CGRect(x: 80, y: 80, width: 90, height: 30)
        
        signAsGusetBtn.layer.cornerRadius = 5
        signAsGusetBtn.layer.borderWidth = 1
        signAsGusetBtn.layer.borderColor = UIColor.black.cgColor
        
        
    }
    
    //To show and hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailText.endEditing(true)
        passTextField.endEditing(true)
    
    }
    
    @IBAction func signInBtnOnClick(_ sender: Any) {
        
        //if email and password fields are not empty
        guard let email = emailText.text, let password = passTextField.text, !password.isEmpty, !email.isEmpty else{
            print("Nope")
            //Error message
            alert(title:"Error", message: "Please fill in Login information")
            return
        }
        
        activityIndicator.startAnimating()
            
        //Calls authenticateNewUser method
        authenticateUser(email: email, password: password)
        }
    
    @IBAction func guestBtnOnClick(_ sender: Any) {
        LoginVC.isGuest = 1
        //Resets user defaults
        UserDefaults.standard.set(nil, forKey: "uID")
    }
    
    //Login User
    func authenticateUser(email: String, password: String){
        
        Auth.auth().signIn(withEmail: email, password: password){(user,error) in
            if user != nil {
                //print("User is authenticated (user has an account)")
                //print("Email:\(email)")
                
                //save uID using key 'uID'; can quit the app then re-launch and they'll still be there on each phone
                
                UserDefaults.standard.set(user?.user.uid, forKey: "uID")

                //Go to MainVC through Navigation Controller (NavVC)
                self.activityIndicator.stopAnimating()
                LoginVC.isGuest = 0 //Not a guest if login succesfully
                
                MainVC.goTo("NavVC", animate: true)
                
            } else {
                //print("ERROR")
                
                //Show alert according to error thrown
                let errCode = AuthErrorCode(rawValue: error!._code)
                
                var errorMsg = ""
                
                switch errCode {
                    case .userNotFound:
                        errorMsg = "Invalid E-mail address entered"
                    case .wrongPassword:
                        errorMsg = "Incorrect Password entered"
                    default:
                        errorMsg = "\(error?.localizedDescription ?? "Error signing into Account")"
                }
                self.activityIndicator.stopAnimating()
                self.alert(title:"Error", message: errorMsg)
            }
        }
    }

    @IBAction func registerBtnOnClick(_ sender: Any) {
        //navGoTo("SignUpVC", animate: true)
        MainVC.goTo("SignUpVC", animate: true)
    }
    
    @IBAction func forgotPasswordBtnOnClick(_ sender: Any) {
        
        resetPassword()
    }
    
    //Forget Password in Login Page
    func resetPassword() {
        if let email = emailText.text, !email.isEmpty{
            Auth.auth().sendPasswordReset(withEmail: email) {(error) in
                if let error = error {
                    //Error occured
                    self.alert(title: "Error", message: "\(error.localizedDescription)")
                } else {
                    self.alert(title: "Email Sent", message: "Email sent to reset password.")
                }
            }
        } else {
            self.alert(title: "Missing Email", message: "Please enter your email in the text field first")
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

