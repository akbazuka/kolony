//
//  SettingsSection.swift
//  Kolony
//
//  Created by Kedlaya on 3/17/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

protocol SectionType: CustomStringConvertible{
    var containsSwitch: Bool { get }
}

enum SettingsSection: Int, CaseIterable, CustomStringConvertible{
    
    case Account
    case Communication
    
    var description: String {
        switch self{
        case .Account: return "Account"
        case .Communication: return "Communication"
        }
    }
    
    static let allValues = [Account, Communication]
}

enum AccountOptions: Int, CaseIterable, SectionType{
    case editUsername
    case editEmail
    case changePassword
    case logout
    
    var containsSwitch: Bool{ return false }
    
    var description: String {
        switch self{
        case .editUsername: return "Change Username"
        case .editEmail: return "Change Email"
        case .changePassword: return "Change Password"
        case .logout: return "Logout"
        }
    }
    
    static let allAccountValues = [editUsername, editEmail, changePassword, logout]
}

enum CommunicationOptions: Int, CaseIterable, SectionType{
    case notifications
    case email
    case reportCrashes
    
    var containsSwitch: Bool{
        switch self{
        case .notifications: return true
        case .email: return true
        case .reportCrashes: return true
        }
    }
    
    var description: String {
        switch self{
        case .notifications: return "Notifications"
        case .email: return "Receive Emails"
        case .reportCrashes: return "Report Crashes"
        }
    }
    
    static let allCommunicationValues = [notifications, email, reportCrashes]
}
