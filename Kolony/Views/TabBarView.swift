//
//  TabBarView.swift
//  
//
//  Created by Kedlaya on 3/14/20.
//

import UIKit

class TabBarView: UITabBar {
    
    
    @IBAction func cartOnClick(_ sender: Any) {
        if UserService.isGuest{
            alert(title: "Hi friend!", message: "This is a user only feature. Please create an acoount with us to be able to access all of our features.")
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
        UINavigationController?.pushViewController(vc, animated: true)
    }
    
    func alert(title: String, message: String) {
        
        //Error Title
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Action Title
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //Present to Screen
        present(alert,animated: true,completion: nil)
    }
    
}
