//
//  FooterView.swift
//  Nickey
//
//  Created by cano on 2016/09/18.
//  Copyright © 2016年 cano. All rights reserved.
//

import UIKit

class FooterView: UICollectionReusableView {
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var ignoreButton: UIButton!
    
    class func nib() -> UINib {
        return UINib (nibName: "FooterView", bundle: Bundle.main)
    }
    
    class func cellReuseIdentifier() -> String {
        return "FooterView"
    }
}
