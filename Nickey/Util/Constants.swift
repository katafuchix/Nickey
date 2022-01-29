//
//  Constants.swift
//  Nickey
//
//  Created by cano on 2016/09/16.
//  Copyright © 2016年 cano. All rights reserved.
//

import UIKit

struct Constants {
    
    // 利用システム名 日記投稿時のオーナー名
    static let systemName = "Nicky"
    static let myName    = "Me"
    
    // section
    static let sections = ["日記設定","プロフィール設定","その他"]
    
    // item
    static let items = [
                        ["パスコード設定","PUSH通知設定", "配信頻度設定", "配信不可時間帯設定"],
                        ["性別","生年月日", "地域"],
                        ["ご意見・ご感想","当アプリについて"]//, "アップデート情報"]
                        ]
    
    // 設定項目
    // テーブルには各項目のindex番号を保存
    
    static let passuse = ["OFF", "ON"]
    
    static let push = ["OFF", "ON"]
    
    static let freq = ["数時間に1度程度（推奨）","1日に数回程度"]
    
    static let sex = ["男性", "女性"]
    
    static let textFieldSize = CGRect(x:10, y:10, width:160, height:35)
    
    static let settingTextFieldSize = CGRect(x:0,y:0,width:200,height:40)
    
    static let pickerSize    = CGRect(x:0, y:0, width:200, height:50)
    
    static let buttonSize    = CGRect(x:0, y:0, width:140, height:40)
    
    static let colorPickerSize = CGRect(x:0,y:0,width:230,height:30)
    
    static let colorViewSize = CGRect(x:0,y:0,width:200,height:40)
    
    static let popUpWidth : CGFloat    = 260.0
    
    static let pickerFontSize : CGFloat    = 18.0
    
    static let buttonFontSize : CGFloat    = 18.0
    
}
