//
//  RoundedUIView.swift
//  Kolony
//
//  Created by Kedlaya on 3/12/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import UIKit

class RoundedShadowView : UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 7
        //layer.shadowColor = UIColor.blue.cgColor
        //layer.shadowOpacity = 0.4
        //layer.shadowOffset = CGSize.zero
        //layer.shadowRadius = 3
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.withAlphaComponent(0.14).cgColor
        //layer.masksToBounds = false
    }
}

class RoundedButton : UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.borderColor = UIColor.black.cgColor
    }
}

