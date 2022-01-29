//
//  HeaderView.swift
//  Nickey
//
//  Created by cano on 2016/09/18.
//  Copyright © 2016年 cano. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    class func nib() -> UINib {
        return UINib (nibName: "HeaderView", bundle: Bundle.main)
    }
    
    class func cellReuseIdentifier() -> String {
        return "HeaderView"
    }
}
