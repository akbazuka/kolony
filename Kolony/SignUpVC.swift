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
    
    static var dataURL = "http://localhost/kolony.php?type="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //backBtn.setTitle("Back", for: .normal)
        //.setTitleColor(UIColor.systemBlue, for: UIControl.State.highlighted)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameText.endEditing(true)
        emailText.endEditing(true)
        passText.endEditing(true)
        confirmPassText.endEditing(true)
    }
    
    @IBAction func registerBtnOnClick(_ sender: Any) {
        
//        let email = emailText.text
//        let password = passText.text
//        let conPassword = confirmPassText.text
        
        //if email and password fields are not empty and if password matches confirm password, register user
        if let username = usernameText.text, let email = emailText.text, let password = passText.text, let confirmPassword = confirmPassText.text,
            !password.isEmpty, !email.isEmpty, !username.isEmpty, password == confirmPassword {
    
            //Calls authenticateNewUser method
            authenticateNewUser(email: email, password: password, username: username)
        }
            
        //Error if email and password fields are empty
        else if let username = usernameText.text, let email = emailText.text, let password = passText.text, let confirmPassword = confirmPassText.text, password.isEmpty || email.isEmpty || confirmPassword.isEmpty || username.isEmpty{
            
            //Error Message
            alert(title: "Error", message: "Text fields cannot be empty")
        }
        
        //If confirm password does not match password input
        else {
            //Error Message
            alert(title: "Error", message: "Your Confirm Password input does not match your Password")
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
    
    //Authenticate User Sign-ups
    func authenticateNewUser(email: String, password: String, username: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) {
            
            (authResult, error)
            
            in
            ///...
            let user = authResult?.user
            UserDefaults.standard.set(user?.uid, forKey: "uID")
            
            //Checking User Value
            if user != nil{
                //Navigates to MainVC through Navigation Controller (NavVC)
                MainVC.goTo("NavVC", animate: true)
                //print("User is NOT NIL")
                
                //Add user to personal database
                self.insertUser(uID: UserDefaults.standard.string(forKey: "uID") ?? "-1", userName: username, email: email)
                
                LoginVC.isGuest = 0 //Not a guest if successfully register (logs in by default after registration)
            }
                
            else {
                //Error goes here if trouble logging in
                self.alert( title: "Error", message: "\(error?.localizedDescription ?? "Error registering account")")
            }
        }
    }
    
    //Push user to database
    func insertUser(uID: String, userName: String, email: String){
        
        //Create url string
        let urlString = SignUpVC.self.dataURL + "insertUser&uID=\(uID)&userName=\(userName)&email=\(email)"
        
        //Encode url
        let result = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Error"
        
        //Create url
        guard let url = URL(string: result) else { return }
        
        //Send url
        URLSession.shared.dataTask(with: url).resume()
        
        print("URL Sent: \(url)")
    }
}
