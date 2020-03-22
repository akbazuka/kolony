//
//  SizeCell.swift
//  Kolony
//
//  Created by Kedlaya on 3/21/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import UIKit

class SizeCell: UICollectionViewCell {
    
//    //Outlets
    @IBOutlet weak var sizeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCellUI()
    }

    func setCellUI(){
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 5.0
    }
}
