//
//  Config.swift
//  Nickey
//
//  Created by cano on 2016/09/19.
//  Copyright © 2016年 cano. All rights reserved.
//


import RealmSwift

class Config: Object {
    dynamic var id: Int64 = 0
    
    // パス利用
    dynamic var passuse: Int64 = 0
    
    // パス
    dynamic var password: String?
    
    //dynamic var category: String?
    
    // Push通知を利用するか
    dynamic var push_flag: Int64 = 0
    
    // 配信頻度
    dynamic var freq: Int64 = 0
    
    // 配信頻度選択
    //dynamic var frequency: Int64 = 0
    
    // 配信不可時間帯
    dynamic var inadvisable_time_start_hour     : String?//: Int64 = 0
    dynamic var inadvisable_time_start_minute   : String?//: Int64 = 0
    dynamic var inadvisable_time_end_hour       : String?//: Int64 = 0
    dynamic var inadvisable_time_end_minute   : String?//: Int64 = 0
    
    // 性別
    dynamic var sex: Int64 = 0
    
    // 誕生日
    dynamic var birthday: NSDate?
    
    // 都道府県
    dynamic var prefecture: Int64 = 0
    
}
