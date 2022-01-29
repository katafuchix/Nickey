//
//  UtilManager.swift
//  Nickey
//
//  Created by cano on 2016/09/16.
//  Copyright © 2016年 cano. All rights reserved.
//

import UIKit
import Device

class UtilManager {

    // ポップアップのサイズ指定用メソッド
    static func getPopUpWidth() ->CGFloat {
        
        if Device.size() == Size.screen5_5Inch {
            return Constants.popUpWidth + 40.0
        }
        if Device.size() == Size.screen4_7Inch {
            return Constants.popUpWidth + 20.0
        }
        return Constants.popUpWidth
    }
    
    // 該当する日時からその日時内のランダム日付を返す
    public static func getRandomTime(date:NSDate)->[NSDate] {
        // realm
        let realm = RealmController.getSharedRealmController()
        let config = realm.getConfig()
        let freq   = config.freq
        
        // 一時用配列
        var dates = Array<NSDate>()
        
        let today = date //NSDate()
        let year = DateUtil.year(date: today)
        let month = DateUtil.month(date: today)
        let day = DateUtil.day(date: today)
        let date_formatter: DateFormatter = DateFormatter()
        //date_formatter.locale     = NSLocale(localeIdentifier: "ja")
        date_formatter.locale     = NSLocale(localeIdentifier: NSLocale.Key.languageCode.rawValue) as Locale!
        date_formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        // "数時間に1度程度（推奨）"  2時間に１回
        if(freq == 0){
            for i in 0 ..< 12 {
                // それぞれの時間帯でランダムな日時を作成
                let d1_str = String(format: "%04d-%02d-%02d %02d:00:00", year,month,day, i*2)
                let d1_date: NSDate = (date_formatter.date(from: d1_str) as NSDate?)!
                
                let d2_str = String(format: "%04d-%02d-%02d %02d:59:59", year,month,day, i*2+1)
                let d2_date: NSDate = (date_formatter.date(from: d2_str) as NSDate?)!
                
                let diff = Int(d2_date.timeIntervalSince1970)-Int(d1_date.timeIntervalSince1970)
                let r    = Int(arc4random_uniform(UInt32(diff))) + Int(d1_date.timeIntervalSince1970)
                
                let rdate = NSDate(timeIntervalSince1970: TimeInterval(r))
                dates.append(rdate)
            }
        }
        //"1日に数回程度"  5時間に１回
        else{
            for i in 0 ..< 5 {
                // それぞれの時間帯でランダムな日時を作成
                let d1_str = String(format: "%04d-%02d-%02d %02d:00:00", year,month,day, i*5)
                let d1_date: NSDate = (date_formatter.date(from: d1_str) as NSDate?)!
                
                // 24時を超えないように
                var val = i*5+4
                if val >= 24 {
                    val = 23
                }
                
                let d2_str = String(format: "%04d-%02d-%02d %02d:59:59", year,month,day, val)
                let d2_date: NSDate = (date_formatter.date(from: d2_str) as NSDate?)!
                
                let diff = Int(d2_date.timeIntervalSince1970)-Int(d1_date.timeIntervalSince1970)
                let r    = Int(arc4random_uniform(UInt32(diff))) + Int(d1_date.timeIntervalSince1970)
                
                let rdate = NSDate(timeIntervalSince1970: TimeInterval(r))
                dates.append(rdate)
            }
        }
        //print("dates : \(dates)")
        
        // DB設定時間と比較する
        let start_hour      = Int(config.inadvisable_time_start_hour!)
        let start_minute    = Int(config.inadvisable_time_start_minute!)
        let end_hour        = Int(config.inadvisable_time_end_hour!)
        let end_minute      = Int(config.inadvisable_time_end_minute!)
        
        let start_dateStr = String(format: "%04d-%02d-%02d %02d:%02d:00", year,month,day, start_hour!, start_minute!)
        let start_date: NSDate = (date_formatter.date(from: start_dateStr) as NSDate?)!
        
        let end_dateStr = String(format: "%04d-%02d-%02d %02d:%02d:00", year,month,day, end_hour!, end_minute!)
        let end_date: NSDate = (date_formatter.date(from: end_dateStr) as NSDate?)!
        
        // 返却用配列
        var ret = Array<NSDate>()
        
        // start < end
        if(start_date.timeIntervalSince1970 < end_date.timeIntervalSince1970){
            for date in dates{
                // 配信停止のstart endの範囲外
                if(date.timeIntervalSince1970 < start_date.timeIntervalSince1970
                    || end_date.timeIntervalSince1970 < date.timeIntervalSince1970){
                    ret.append(date)
                }
            }
        }
        // start > end
        else if (start_date.timeIntervalSince1970 > end_date.timeIntervalSince1970){
            for date in dates{
                // 配信停止のstart endの範囲外
                if(end_date.timeIntervalSince1970 < date.timeIntervalSince1970
                    && date.timeIntervalSince1970 < start_date.timeIntervalSince1970){
                    ret.append(date)
                }
            }
        }
        // start == end
        else{
            ret = dates
        }
        return ret
    }
    
    
    // ランダム日時生成メソッド テスト確認用
    public static func randomWithinDaysBeforeToday(days: Int) -> NSDate {
        // realm
        let realm = RealmController.getSharedRealmController()
        let config = realm.getConfig()
        
        let start_hour      = Int(config.inadvisable_time_start_hour!)
        let start_minute    = Int(config.inadvisable_time_start_minute!)
        let end_hour        = Int(config.inadvisable_time_end_hour!)
        let end_minute      = Int(config.inadvisable_time_end_minute!)
        
        // 現在時刻
        let today = NSDate()
        
        let year = DateUtil.year(date: today)
        let month = DateUtil.month(date: today)
        let day = DateUtil.day(date: today)
        let date_formatter: DateFormatter = DateFormatter()
        //date_formatter.locale     = NSLocale(localeIdentifier: "ja")
        date_formatter.locale     = NSLocale(localeIdentifier: NSLocale.Key.languageCode.rawValue) as Locale!
        date_formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        let start_dateStr = String(format: "%04d-%02d-%02d %02d:%02d:00", year,month,day, start_hour!, start_minute!)
        //print("start_dateStr : \(start_dateStr)")
        let start_date: NSDate = (date_formatter.date(from: start_dateStr) as NSDate?)!
        //print(start_date.timeIntervalSince1970)
        
        let end_dateStr = String(format: "%04d-%02d-%02d %02d:%02d:00", year,month,day, end_hour!, end_minute!)
        //print("end_dateStr : \(end_dateStr)")
        let end_date: NSDate = (date_formatter.date(from: end_dateStr) as NSDate?)!
        //print(end_date.timeIntervalSince1970)
        
        // start < end
        if(start_date.timeIntervalSince1970 < end_date.timeIntervalSince1970){
            // 00:00から配信停止開始時間までのランダム時間を算出
            let time00str = String(format: "%04d-%02d-%02d 00:00:00", year,month,day)
            let time00: NSDate = (date_formatter.date(from: time00str) as NSDate?)!
            print(time00.timeIntervalSince1970)
            
            let diff1 = Int(start_date.timeIntervalSince1970)-Int(time00.timeIntervalSince1970)
            let r1 = Int(arc4random_uniform(UInt32(diff1))) + Int(time00.timeIntervalSince1970)
            //print("r1 : \(r1)")
            
            let r1date = NSDate(timeIntervalSince1970: TimeInterval(r1))
            //print("r11 : \(r1date)")
            
            // 配信停止終了時間から23:59:59までのランダム時間を算出
            let time23str = String(format: "%04d-%02d-%02d 23:59:59", year,month,day)
            let time23: NSDate = (date_formatter.date(from: time23str) as NSDate?)!
            print(time23.timeIntervalSince1970)
            
            let diff2 = Int(time23.timeIntervalSince1970)-Int(end_date.timeIntervalSince1970)
            let r2 = Int(arc4random_uniform(UInt32(diff2))) + Int(end_date.timeIntervalSince1970)
            //print("r2 : \(r2)")
            
            let r2date = NSDate(timeIntervalSince1970: TimeInterval(r2))
            //print("r22 : \(r2date)")
            
            let rand = Int(arc4random_uniform(UInt32(10)))
            
            if(rand%2==0){
                return r1date
            }else{
                return r2date
            }
        }
        
        // start > end
        else if (start_date.timeIntervalSince1970 > end_date.timeIntervalSince1970){
            let diff = Int(start_date.timeIntervalSince1970)-Int(end_date.timeIntervalSince1970)
            let r1 = Int(arc4random_uniform(UInt32(diff))) + Int(end_date.timeIntervalSince1970)
            print("r1 : \(r1)")
            let r1date = NSDate(timeIntervalSince1970: TimeInterval(r1))
            print("r11 : \(r1date)")
            return r1date
        }
        
        // 以下startとendが同じ場合
        guard let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian) else {
            print("no calendar \"NSCalendarIdentifierGregorian\" found")
            return today
        }
        let r1 = arc4random_uniform(UInt32(days))
        let r2 = arc4random_uniform(UInt32(23))
        let r3 = arc4random_uniform(UInt32(23))
        let r4 = arc4random_uniform(UInt32(23))
        
        let offsetComponents = NSDateComponents()
        offsetComponents.day = Int(r1) * -1
        offsetComponents.hour = Int(r2)
        offsetComponents.minute = Int(r3)
        offsetComponents.second = Int(r4)
        
        guard let rndDate1 = gregorian.date(byAdding: offsetComponents as DateComponents, to: today as Date, options: []) else {
            print("randoming failed")
            return today
        }
        return rndDate1 as NSDate
    }
}
