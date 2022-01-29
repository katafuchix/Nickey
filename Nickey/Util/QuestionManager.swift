//
//  QuestionManager.swift
//  Nickey
//
//  Created by cano on 2016/10/23.
//  Copyright © 2016年 cano. All rights reserved.
//

import UIKit

class QuestionManager {
    
    // Question.txt をindexと質問文を辞書にしたもの
    var dic : Dictionary<Int,String> = Dictionary<Int,String>()
    
    // Question.txt をindexと開始時刻を辞書にしたもの
    var startTimeDic : Dictionary<Int,String> = Dictionary<Int,String>()
    
    // Question.txt をindexと終了時刻を辞書にしたもの
    var endTimeDic : Dictionary<Int,String> = Dictionary<Int,String>()
    
    // 初期化処理
    public init(){
        dic             = Dictionary<Int,String>()
        startTimeDic    = Dictionary<Int,String>()
        endTimeDic      = Dictionary<Int,String>()
        
        if let path = Bundle.main.path(forResource: "Question", ofType: "txt"){
            if let data = NSData(contentsOfFile: path){
                let str = String(NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)!)
                
                // 改行で分割
                var valArray = str.components(separatedBy:"\n")
                
                // 全体を回す
                for i in 0 ..< valArray.count {
                    var vals = valArray[i].components(separatedBy:",")
                    // コメントはスルー
                    if( vals.count != 4){ continue }
                    
                    let key = Int(vals[0])
                    dic[key!]               = vals[1]
                    startTimeDic[key!]      = vals[2]
                    endTimeDic[key!]        = vals[3]
                }
            }
        } else {
            print("not found")
        }
    }
    
    // noから質問情報を取得する
    func getInfo(_ no:Int) -> [String] {
        return [dic[no]!, startTimeDic[no]!, endTimeDic[no]!]
    }
    
    // 時刻から該当する質問Noをランダムに取得する
    func getQuestionByTime(date:NSDate)->Int{
        // 日付を解析
        let today = date
        let year = DateUtil.year(date: today)
        let month = DateUtil.month(date: today)
        let day = DateUtil.day(date: today)
        let date_formatter: DateFormatter = DateFormatter()
        //date_formatter.locale     = NSLocale(localeIdentifier: "ja")
        date_formatter.locale     = NSLocale(localeIdentifier: NSLocale.Key.languageCode.rawValue) as Locale!
        date_formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        var array = Array<Int>()
        
        // 日時チェック
        for(key, val) in dic {
            let start = startTimeDic[key]
            let end   = endTimeDic[key]
            
            let s_str = String(format: "%04d-%02d-%02d %@:00", year,month,day, start!)
            let s_date: NSDate = (date_formatter.date(from: s_str) as NSDate?)!
            
            
            let e_str = String(format: "%04d-%02d-%02d %@:00", year,month,day, end!)
            let e_date: NSDate = (date_formatter.date(from: e_str) as NSDate?)!
            
            if(s_date.timeIntervalSince1970 < date.timeIntervalSince1970
                && date.timeIntervalSince1970 < e_date.timeIntervalSince1970){
                array.append(key)
            }
        }
        // 該当する時刻の中から質問Noをランダムに1つ返却
        let c = array.count-1
        let rand = arc4random_uniform(UInt32(c))
        return array[Int(rand)]
        /*
        for key in array {
            print(key)
            print(dic[key])
            print(startTimeDic[key])
            print(endTimeDic[key])
        }
        */
    }
}
