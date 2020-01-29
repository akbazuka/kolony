//
//  SwiftUIView.swift
//  Book Buddy
//
//  Created by Kedlaya on 1/25/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var MenuLeadingConstraint: NSLayoutConstraint!

    var showMenu = false

    @IBOutlet weak var menuButton: UIButton!

    @IBOutlet weak var filterButton: UIButton!

    @IBOutlet weak var mainTintedV: UIView!

    var tapGesture = UITapGestureRecognizer()

    let attributes = [NSAttributedString.Key.font: UIFont(name: "ChalkboardSE-Regular", size: 20)!] //For changing font of navigation bar title

    override func viewDidLoad() {
        super.viewDidLoad()

        MenuLeadingConstraint.constant = -218 //Presents (default) menu bar to hide

        mainTintedV.isHidden = true //Hides tinted VC by default
        UINavigationBar.appearance().titleTextAttributes = attributes //Changes font of navigation bar title

        //Initialization of tap gesture
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapOutsideMenu(_:)))
        mainTintedV.addGestureRecognizer(tapGesture)
        mainTintedV.isUserInteractionEnabled = true

        //changeMenuImageClose() //Set backgorund image for menu button
    }

    //Menu opens and closes as hamburger button is pressed
    @IBAction func menuButtonPressed(_ sender: Any) {

    if (showMenu){ //When menu is visible
            MenuLeadingConstraint.constant = -218 //remove menu from view

            mainTintedV.isHidden = true //Hides tinted VC

            changeMenuImageClose()
        }
        else { //When menu is not visible
            MenuLeadingConstraint.constant = 0 //show menu in view

            mainTintedV
                .isHidden = false //Shows tinted VC

            changeMenuImageOpen()
        }

        UIView.animate(withDuration: 0.3, animations:{
            self.view.layoutIfNeeded()
        })

        showMenu = !showMenu //Either shows or hides menu depending on current state, when hamburger button is pressed
    }

    //When view is tapped outside the menu, the menu closes
    @objc func tapOutsideMenu(_ sender: UITapGestureRecognizer) {

        MenuLeadingConstraint.constant = -218 //remove menu from view

        mainTintedV.isHidden = true //Hides tinted VC

        showMenu = false

        changeMenuImageClose()

        UIView.animate(withDuration: 0.3, animations:{
            self.view.layoutIfNeeded()

        })
    }

    //Set backgorund image for menu button to closed state
    func changeMenuImageClose() {
        menuButton.setImage(UIImage(named: "menuVertical"), for: .normal) //Set backgorund image for menu button
    }

    //Set backgorund image for menu button to open state
    func changeMenuImageOpen() {
        menuButton.setImage(UIImage(named: "menuHorizontal"), for: .normal) //Set backgorund image for menu button //Set backgorund image for menu button
    }

}
