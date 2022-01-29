//
//  CalenderCell.swift
//  Nickey
//
//  Created by cano on 2016/09/13.
//  Copyright © 2016年 cano. All rights reserved.
//

import UIKit

class CalenderCell: UICollectionViewCell {

    var textLabel: UILabel!
    var dataLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // UILabelを生成
        textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        textLabel.font = UIFont(name: "HiraKakuProN-W3", size: 12)
        textLabel.textAlignment = NSTextAlignment.center
        // Cellに追加
        self.addSubview(textLabel!)
        
        // UILabelを生成
        dataLabel = UILabel(frame: CGRect(x: 0, y: self.frame.height*1/2, width: self.frame.width, height: self.frame.height*1/2))
        dataLabel.font = UIFont(name: "HiraKakuProN-W3", size: 5)
        dataLabel.textAlignment = NSTextAlignment.center
        //dataLabel.backgroundColor = UIColor.black
        // Cellに追加
        self.addSubview(dataLabel!)
        
    }
    
}
