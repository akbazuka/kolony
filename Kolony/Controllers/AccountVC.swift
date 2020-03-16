//
//  AccountVC.swift
//  Kolony
//
//  Created by Kedlaya on 3/15/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import UIKit

class AccountVC : UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       blockGuestUser()
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
    
    //Navigate to homeVC
    @IBAction func homeBtnOnClick(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for vc in viewControllers {
            if vc is MainVC {
                self.navigationController!.popToViewController(vc, animated: true)
            }
        }
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
    }
}
