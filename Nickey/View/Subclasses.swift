//
//  Subclasses.swift
//  SwiftExample
//
//  Created by Tal Shachar on 14/09/2016.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

import Foundation
import JSQMessagesViewController

/*
class MessageSizeCalculator:JSQMessagesBubblesSizeCalculator{
    override func messageBubbleSizeForMessageData(messageData: JSQMessageData, atIndexPath indexPath: NSIndexPath, withLayout layout: (JSQMessagesCollectionViewFlowLayout!)) -> CGSize {
        let defaultSize = super.messageBubbleSizeForMessageData(messageData, atIndexPath: indexPath, withLayout: layout)
        
        if indexPath.row == 3{
            //Custom message
            let heigt = SystemMessageCell.heightForMessage(message: messageData.text!(),width: layout.collectionView.bounds.width)
            return CGSize(width: layout.collectionView.bounds.width, height: heigt)
        }
        return defaultSize
    }
}
*/
