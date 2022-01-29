//
//  SystemMessageCell.swift
//  SwiftExample
//
//  Created by Tal Shachar on 14/09/2016.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

import UIKit

class SystemMessageCell: UICollectionViewCell {


    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    class func nib() -> UINib {
        return UINib (nibName: "SystemMessageCell", bundle: Bundle.main)
    }
    
    class func cellReuseIdentifier() -> String {
        return "SystemMessageCell"
    }
    
    func refreshCell(title: String, description:String) {
        self.titleLable.text = title
        self.descriptionLabel.text = description;
    }
    
    class func heightForMessage(message: String, width: CGFloat) -> CGFloat {
        let viewArray = Bundle.main.loadNibNamed("SystemMessageCell", owner: nil, options: nil)
        let cell: SystemMessageCell = (viewArray![0] as? SystemMessageCell)!
        
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
