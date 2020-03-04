//
//  ViewController.swift
//  Book Buddy
//
//  Created by Kedlaya on 1/20/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var signAsGusetBtn: UIButton!
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        userNameTextField.endEditing(true)
        passTextField.endEditing(true)
    
    }

    @IBAction func registerBtnOnClick(_ sender: Any) {
        //navGoTo("SignUpVC", animate: true)
        MainVC.goTo("SignUpVC", animate: true)
    }
}

