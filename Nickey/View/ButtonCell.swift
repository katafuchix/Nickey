//
//  ButtonCell.swift
//  Nickey
//
//  Created by cano on 2016/09/18.
//  Copyright © 2016年 cano. All rights reserved.
//

import UIKit

class ButtonCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLable: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    
    class func nib() -> UINib {
        return UINib (nibName: "ButtonCell", bundle: Bundle.main)
    }
    
    class func cellReuseIdentifier() -> String {
        return "ButtonCell"
    }
    
    func refreshCell(title: String, description:String) {
        self.titleLable.text = title
        //self.descriptionLabel.text = description;
    }
    
    class func heightForMessage(message: String, width: CGFloat) -> CGFloat {
        let viewArray = Bundle.main.loadNibNamed("ButtonCell", owner: nil, options: nil)
        let cell: ButtonCell = (viewArray![0] as? ButtonCell)!
        
        cell.refreshCell(title: message, description: message)
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        cell.bounds = CGRect(x: 0.0, y: 0.0, width: width, height: cell.bounds.height)
        
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        var height = cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        
        height += 1.0
        return height
    }
}
