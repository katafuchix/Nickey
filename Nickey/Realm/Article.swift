//
//  Article.swift
//  Nickey
//
//  Created by cano on 2016/09/19.
//  Copyright © 2016年 cano. All rights reserved.
//

import RealmSwift

class Article: Object {

    dynamic var id: Int64 = 0
    dynamic var date: NSDate?
    dynamic var owner: String?
    dynamic var text: String?
    dynamic var status: Int64 = 1   // 通知用の日記は未来日付の0で登録  現在時間を過ぎたら1にする
    dynamic var order: Int64 = 1
    
    //インデックスの設定
    override public static func indexedProperties() -> [String] {
        return ["id"]
    }
    //プライマリキーの設定
    override public static func primaryKey() -> String? {
        return "id"
    }
    
}
