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
    
    func navBarSetup(){
        //self.navigationController?.navigationItem.title = "My Orders"
        self.title = "Settings"
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
            } catch {
                Auth.auth().handleFireAuthError(error: error, vc: self)
                debugPrint(error)
            }
        }
        case .Communication:
            print("Aloha")
        }
    }
}
