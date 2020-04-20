//
//  Extensions.swift
//  Kolony
//
//  Created by Kedlaya on 3/13/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import UIKit
import Firebase

/*Extension to format numbers from pennies to dollars*/
extension Int{
    
    func penniesToFormattedCurrency() -> String{
        //Int to dollars: Eg: 124 -> 1.24
        let dollars = Double(self) / 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let dollarString = formatter.string(from: dollars as NSNumber) {
            return dollarString
        }
        
        return "$0.00"
    }
}

/* Extension to format number to local currency */
extension Double{
    
    var asLocaleCurrency:String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current //for current locale
        return formatter.string(from: NSNumber(value: self))!
    }
    
    var asUSCurrency:String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")  //for dollar locale
        return formatter.string(from: NSNumber(value: self))!
    }
}

/*For converting Timestamp to readable date format*/
extension Timestamp{
    var asDate:String{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self.dateValue())
    }
}

/*For Different kinds of alerts*/
extension UIViewController{
    //Basic Alert Popup
    func alert(title: String, message: String) {
        
        //Error Title
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Action Title
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //Present to Screen
        present(alert,animated: true, completion: nil)
    }
    
    //Navigate to VC after Alert (to Navigation Controller)
    func alertNavToVC(title:String, message: String, toVC: String) {
        //Error Title
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Action Title
        //alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { UIAlertAction in
            //Go to view controller through naigation controller
            let navToVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: toVC)
            self.navigationController?.pushViewController(navToVC, animated: true)
        })
        //Present to Screen
        present(alert,animated: true, completion: nil)
    }
    
    //Navigate to VC after Alert (without navigation controller)
    func alertToVC(title:String, message: String, toVC: String) {
        //Error Title
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Action Title
        //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Sign-Up", style: .default){UIAlertAction in let
            //Present VC modally
            goToVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: toVC)
        self.present(goToVC, animated: true, completion: nil)})
        
        //Present to Screen
        present(alert,animated: true, completion: nil)
    }
    
    //Navigate to MainVC after Alert (to Navigation Controller); by popping VCs
    func alertNavToMain(title:String, message: String) {
        //Error Title
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Action Title
        //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { UIAlertAction in
            //Go to view controller through naigation controller
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers
            for vc in viewControllers {
                if vc is MainVC {
                    self.navigationController!.popToViewController(vc, animated: true)
                }
            }
        })
        //Present to Screen
        present(alert,animated: true, completion: nil)
    }
}
