//
//  SettingsCell.swift
//  Kolony
//
//  Created by Kedlaya on 3/17/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    static var cellName = ""
    
    // MARK: Properties
    var sectionType: SectionType? {
        didSet{
            guard let sectionType = sectionType else { return }
            textLabel?.text = sectionType.description
            switchControl.isHidden = !sectionType.containsSwitch
        }
    }
    
    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = true
        switchControl.onTintColor = UIColor.green
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
        
        return switchControl
    }()
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(switchControl)
        switchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        switchControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selector
    @objc func handleSwitchAction(sender: UISwitch){
        //If user hits notification switch
        if self.sectionType?.description == "Notifications"{
            print("Notifications")
            //Turn on case
            if sender.isOn{
                print("\(sender) Turned on")
            //Turn off case
            } else {
                print("\(sender) Turned Off")
            }
        //If user hits receive email switch
        } else if self.sectionType?.description == "Receive Emails"{
            print("Receive Emails")
            //Turn on case
            if sender.isOn{
                print("\(sender) Turned on")
            //Turn off case
            } else {
                print("\(sender) Turned Off")
            }
        //If user hits report crashes switch
        } else { print("Aloha")
            //Turn on case
            if sender.isOn{
                print("\(sender) Turned on")
            //Turn off case
            } else {
                print("\(sender) Turned Off")
            }
        }
    }
}
