//
//  AccountVC.swift
//  Kolony
//
//  Created by Kedlaya on 3/15/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import UIKit
import FirebaseAuth

private let reuseIdentifier = "SettingsCell"

class AccountVC : UIViewController{
    
    // MARK: - Properties
    var tableView: UITableView!
    var userInfoHeader: UserInfoHeader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        blockGuestUser()
        navBarSetup()
    }
    
    // MARK: - Helper Functions
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.frame = view.frame

        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 100)
        userInfoHeader = UserInfoHeader(frame: frame)
        tableView.tableHeaderView = userInfoHeader
        tableView.tableFooterView = UIView() //Only gives as many separator lines as cells
    }
    
    func configureUI() {
        configureTableView()
        //navigationController?.navigationBar.prefersLargeTitles = true
        //navigationController?.navigationBar.isTranslucent = false
        //navigationController?.navigationBar.barStyle = .black
        //navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        //navigationItem.title = "Settings"
    }
    
    //Don't allow guest user to visit CheckoutVC
    func blockGuestUser(){
        if UserService.isGuest == true{
            self.blurBackground()
            
            let alertController = UIAlertController(title: "Hi friend!", message: "This is a user only feature. Please create an account with us to be able to access all of our features. It's free to Sign-up", preferredStyle: .alert)
            
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
    
    func navBarSetup(){
        //self.navigationController?.navigationItem.title = "My Orders"
        self.title = "Settings"
    }
    
    func blurBackground(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    //Navigate to VC after Alert (to Navigation Controller)
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
    
    //Navigate to VC after Alert (to Navigation Controller)
    func alert(title:String, message: String) {
        //Error Title
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Action Title
        //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //Present to Screen
        present(alert,animated: true, completion: nil)
    }
    
    //Validate email regex
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
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
    
    func inputAlert(option: String){
        let fullMessage = option.split(separator: " ") //Split by space
        let partMessage = fullMessage[1].lowercased()
        
        let alert = UIAlertController(title: "Change \(partMessage)", message: "Please enter your new \(partMessage)", preferredStyle: .alert)
        
        var sensitive = false
        
        if option == "Change Password"{
            sensitive = true
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "New \(partMessage)"
            textField.isSecureTextEntry = sensitive //only true if password
        }

        alert.addTextField { (textField) in
            textField.placeholder = "Confirm \(partMessage)"
            textField.isSecureTextEntry = sensitive //only true if password
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (action) in
            //If input fields are not empty and they macth
            if let userText = alert.textFields?[0].text,!userText.isEmpty, let userText1 = alert.textFields?[1].text, !userText1.isEmpty, userText == userText1 {
                
                switch option{
                case "Change Username":
                    //Update username in Firestore Database
                    UserService.updateUser(new: userText, type: "username")

                case "Change Email":
                    //Checks if email address is well formatted
                    if self.isValidEmail(userText){
                        //Update email in Firebase Authentication
                        Auth.auth().currentUser?.updateEmail(to: userText, completion: { (error) in
                            if let error = error {
                                debugPrint(error)
                                Auth.auth().handleFireAuthError(error: error, vc: self)
                                print("Nope")
                            }
                        })
                        //Update email in Firestore Database
                        UserService.updateUser(new: userText, type: "email")
                        //Update user defaut for emai
                        UserDefaults.standard.set(userText, forKey: "email")
                    } else {
                        self.alert(title: "Error", message: "Please enter a valid e-mail address.")
                        return
                    }

                case "Change Password":
                    //Checks if password is at least 6 characters in length
                    if userText.count >= 6{
                        //Update password in Firebase Authentication
                        Auth.auth().currentUser?.updatePassword(to: userText, completion: { (error) in
                            if let error = error {
                                debugPrint(error)
                                Auth.auth().handleFireAuthError(error: error, vc: self)
                            }
                        })
                        //Update user defaut for password
                        UserDefaults.standard.set(userText, forKey: "password")
                    } else {
                        self.alert(title: "Error", message: "Please enter a password of at least 6 characters.")
                        return
                    }
                default:
                    return
                }
                
                self.blurBackground()   //Blur background before presenting success message
                self.alertNavToMain(title: "Congratulations!", message: "Your \(partMessage) was updated successfully!")
                
            } else if let userText = alert.textFields?[0].text, let userText1 = alert.textFields?[1].text, userText.isEmpty || userText1.isEmpty {
                //If user leaves text fields empty
                self.alert(title: "Error", message: "Please fill out all text fields.")
            } else {
                //If inputs did not match
                self.alert(title: "Error", message: "Your inputs did not match, please try again.")
            }
        }))

        self.present(alert, animated: true, completion: nil)
    }
}

extension AccountVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allValues.count //No. of sections in Table View
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = SettingsSection(rawValue: section) else { return 0 }
        
        switch section{
            //No. of rows in each section
        case .Account: return AccountOptions.allAccountValues.count
        case .Communication: return CommunicationOptions.allCommunicationValues.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        //For section heares
        view.backgroundColor = .black
        
        let title = UILabel()
        title.font = UIFont(name: "Avenir-Next-Medium", size: 18)
        title.textColor = .white
        title.text = SettingsSection(rawValue: section)?.description //Instantiate settings section with raw Int values from SettingsSection enum
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        //Guard statement unwraps optional values with a default return
        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section{
        case .Account:
            let account = AccountOptions(rawValue: indexPath.row)
            cell.sectionType = account
        case .Communication:
            let communication = CommunicationOptions(rawValue: indexPath.row)
            cell.sectionType = communication
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }
        
        switch section{
        case .Account:
            if(AccountOptions(rawValue: indexPath.row)?.description) == "Logout" {
            do {
                try Auth.auth().signOut()
                UserService.logoutUser()
                Auth.auth().signInAnonymously { (result, error) in
                    if let error = error {
                        Auth.auth().handleFireAuthError(error: error, vc: self)
                        debugPrint(error)
                    }
                    tableView.deselectRow(at: indexPath, animated: true)
                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil) //Goes back to root view controller
                    //self.navigationController?.popToRootViewController(animated: true)
                }
                tableView.deselectRow(at: indexPath, animated: true)
            } catch {
                Auth.auth().handleFireAuthError(error: error, vc: self)
                debugPrint(error)
            }
            } else if (AccountOptions(rawValue: indexPath.row)?.description) == "Change Username"{
                inputAlert(option: "Change Username")
                tableView.deselectRow(at: indexPath, animated: true)
                
            } else if (AccountOptions(rawValue: indexPath.row)?.description) == "Change Email"{
                inputAlert(option: "Change Email")
                tableView.deselectRow(at: indexPath, animated: true)
            } else {
                inputAlert(option: "Change Password")
                tableView.deselectRow(at: indexPath, animated: true)
            }
        case .Communication:
            print("Aloha")
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
