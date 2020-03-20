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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        buttonLayouts()
        
        //Checks if user defaults exists before the view is shown
        ifUserDefaultExists()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //Resets fields and activity indicator
        emailText.text = ""
        passTextField.text = ""
        activityIndicator.isHidden = true
    }
    
    //Login User with existing credentials if they exist
    func ifUserDefaultExists(){
        if UserDefaults.standard.object(forKey: "email") != nil{
            
            authenticateUser(email: UserDefaults.standard.object(forKey: "email") as! String, password: UserDefaults.standard.object(forKey: "password") as! String)
        } else {
            UserDefaults.standard.set(nil, forKey: "email")
            UserDefaults.standard.set(nil, forKey: "password")
        }
    }
    
    func buttonLayouts(){
        registerButton.layer.cornerRadius = 5
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.black.cgColor
        
        signAsGusetBtn.layer.cornerRadius = 5
        signAsGusetBtn.layer.borderWidth = 1
        signAsGusetBtn.layer.borderColor = UIColor.black.cgColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailText.endEditing(true)
        passTextField.endEditing(true)
    }
    
    @IBAction func signInBtnOnClick(_ sender: Any) {
        
        //if email and password fields are not empty
        guard let email = emailText.text , !email.isEmpty ,
            let password = passTextField.text , !password.isEmpty else {
                alert(title: "Error", message: "Please fill in Login information.")
                return
        }
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        authenticateUser(email: email, password: password)
    }
    
    @IBAction func guestBtnOnClick(_ sender: Any) {
        //Go to MainVC through Navigation Controller (NavVC)
        //self.dismiss(animated: true, completion: nil)
    }
    
    //Login User
    func authenticateUser(email: String, password: String){
        
        Auth.auth().signIn(withEmail: email, password: password){(user,error) in
            if user != nil {

                self.activityIndicator.stopAnimating()
                //Set user defaults
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(password, forKey: "password")
                
                //Go to MainVC through Navigation Controller (NavVC)
                /*self.dismiss(animated: true){
                    MainVC.goTo("NavVC", animate: true)
                }*/
                
                //Go to MainVC
                let navVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavVC")
                self.present(navVC, animated: true, completion: nil)
                
            } else {
                
                //Show alert according to error thrown
                if let error = error {
                    debugPrint(error)
                    Auth.auth().handleFireAuthError(error: error, vc: self)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    return
                }
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    @IBAction func registerBtnOnClick(_ sender: Any) {
        //Present SignUpVC modally
        let signUpVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC")
        self.present(signUpVC, animated: true, completion: nil)
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
                    Auth.auth().handleFireAuthError(error: error, vc: self)
                } else {
                    self.alert(title: "Email Sent", message: "Email sent to reset password.")
                }
            }
        } else {
            self.alert(title: "Email Field is Empty", message: "Please enter your email address in the text field and we will send you an email to change your password.")
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

