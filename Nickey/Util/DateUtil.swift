//
//  DateUtil.swift
//  Nickey
//
//  Created by cano on 2016/09/25.
//  Copyright © 2016年 cano. All rights reserved.
//

import UIKit

class DateUtil: NSObject {
    public static let weekdaysjp = ["","日","月","火","水","木","金","土"]
    public static let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)! //カレンダーデータ
    static let DATE_FORMAT = "yyyy/MM/dd HH:mm:ss"
    static let DAY_START_STR = "00:00:00"
    
    // 日付の年で表される部分を整数型の値で返します
    // パラメータ
    //  date : 日付データ(NSDate型)を指定します
    //
    public static func year(date: NSDate) -> Int {
        //let calendar = NSCalendar.current
        //let comp : NSDateComponents = calendar.components(NSCalendar.Unit.Year, fromDate: date)
        let comp = (Calendar.current as NSCalendar).components([.year, .month, .day],
                                                                     from: date as Date)
        return comp.year!
    }
    
    // 日付の月で表される部分を整数型の値で返します
    // パラメータ
    //  date : 日付データ(NSDate型)を指定します
    //
    public static func month(date: NSDate) -> Int {
        /*
        let calendar = NSCalendar.current
        let comp : NSDateComponents = calendar.components(
            NSCalendar.Unit.Month, fromDate: date)
         */
        let comp = (Calendar.current as NSCalendar).components([.year, .month, .day],
                                                               from: date as Date)
        return comp.month!
    }
    
    // 日付の日で表される部分を整数型の値で返します
    // パラメータ
    //  date : 日付データ(NSDate型)を指定します
    //
    public static func day(date: NSDate) -> Int {
        /*
        let calendar = NSCalendar.currentCalendar
        let comp : NSDateComponents = calendar.components(
            NSCalendarUnit.Day, fromDate: date)
        */
        let comp = (Calendar.current as NSCalendar).components([.year, .month, .day],
                                                               from: date as Date)
        return comp.day!
    }
    
    // 曜日を表す数値を含む整数型 の値を返します
    // パラメータ
    //  date : 日付データ(NSDate型)を指定します
    // 戻り値
    //  1 日曜日,2 月曜日,3 火曜日, ... ,7 土曜日
    //
    public static func weekday(date: NSDate) -> Int {
        /*
        let calendar = NSCalendar.currentCalendar()
        let comp : NSDateComponents = calendar.components(
            NSCalendarUnit.Weekday, fromDate: date)
         */
        let comp = (Calendar.current as NSCalendar).components([.year, .month, .day, .weekday],
                                                               from: date as Date)
        return comp.weekday!
    }
    
    // 曜日の文字列を返す
    /*
    public static func weekday_str(date: NSDate) -> String {
        let weekday_i = weekday(date: date)
        return weekday[weekday_i]
    }
    */
    // 曜日の文字列を返す
    public static func weekday_str_jp(date: NSDate?) -> String {
        if (date == nil) {
            return "?"
        }
        let weekday_i = weekday(date: date!)
        return weekdaysjp[weekday_i]
    }
    // 日付の時刻で表される部分を整数型の値で返します
    // パラメータ
    //  date : 日付データ(NSDate型)を指定します
    //
    public static func hour(date: NSDate) -> Int {
        /*
        let calendar = NSCalendar.currentCalendar()
        let comp : NSDateComponents = calendar.components(
            NSCalendarUnit.Hour, fromDate: date)
         */
        let comp = (Calendar.current as NSCalendar).components([.year, .month, .day, .weekday, .hour, .minute],
                                                               from: date as Date)
        return comp.hour!
    }
    
    // 日付の分で表される部分を整数型の値で返します
    // パラメータ
    //  date : 日付データ(NSDate型)を指定します
    //
    public static func minute(date: NSDate) -> Int {
        /*
        let calendar = NSCalendar.currentCalendar()
        let comp : NSDateComponents = calendar.components(
            NSCalendarUnit.Minute, fromDate: date)
        */
        let comp = (Calendar.current as NSCalendar).components([.year, .month, .day, .weekday, .hour, .minute],
                                                               from: date as Date)
        return comp.minute!
    }
    /*
    // targetの日付が、start endの範囲ないだったらtrue
    public static func contains(start: NSDate, end: NSDate, target: NSDate) -> Bool {
        return isAscDate(d1: start, d2: target) && isDescDate(d1: end, d2: target)
    }
    
    // d1,d2の日付が同値かどうか
    public static func isSameDate(d1: NSDate, d2: NSDate) -> Bool {
        let calendar = NSCalendar.current
        let compare = calendar.compareDate(d1, toDate: d2, toUnitGranularity: NSCalendar.Unit.Minute)
        return compare == NSComparisonResult.OrderedSame
    }
    // d1,d2の日付(時間を除いて)が同値かどうか
    public static func isSameDateByDay(d1: NSDate, d2: NSDate) -> Bool {
        let calendar = NSCalendar.current
        let compare = calendar.compareDate(d1, toDate: d2, toUnitGranularity: NSCalendar.Unit.Day)
        return compare == NSComparisonResult.OrderedSame
    }
    // d1,d2の日付が昇順かどうか
    public static func isAscDate(d1: NSDate?, d2: NSDate?) -> Bool {
        if d1 == nil || d2 == nil {
            return true
        }
        let calendar = NSCalendar.currentCalendar()
        let compare = calendar.compareDate(d1!, toDate: d2!, toUnitGranularity: NSCalendarUnit.Minute)
        return compare == NSComparisonResult.OrderedAscending
    }
    // d1,d2の日付が降順かどうか
    public static func isDescDate(d1: NSDate, d2: NSDate) -> Bool {
        let calendar = NSCalendar.currentCalendar()
        let compare = calendar.compareDate(d1, toDate: d2, toUnitGranularity: NSCalendarUnit.Minute)
        return compare == NSComparisonResult.OrderedDescending
    }
    */
/*
    // 開始日〜終了日の日付欄に表示する文字列を取得する
    public static func getDateLabelStr(start: NSDate, end: NSDate) -> String {
        var result = ""
        let current_year: Int = DateUtil.year(NSDate())
        
        var tmp             = end
        var eHour           = DateUtil.hour(end)
        var eMinute         = DateUtil.minute(end)
        
        // endの時刻が 00:00 の場合は前日の24:00で表示する
        if eHour == 0 && eMinute == 0 {
            tmp     = NSDate(timeInterval:(24*60*60)*(-1), sinceDate: end)
            eHour   = 24
            eMinute = 0
        }
        let eYear           = DateUtil.year(tmp)
        let eMonth          = DateUtil.month(tmp)
        let eDay            = DateUtil.day(tmp)
        
        // 日本語の場合
        if(CommonUtil.isJa()){
            if year(start) > current_year {
                result += "\(year(start))年"
            }
            result += "\(month(start))月\(day(start))日(\(weekday_str_jp(start)))"
            //0時 or 6時 - 23:59の予定は一日の予定
            if DateUtil.isDaySplitEvent(start, end: end) {
                //何もしない
            } else {
                let str = String(NSString(format: "%02d:%02d", hour(start), minute(start)))
                result += str
            }
            
            result += "〜"
            
            if year(start) != eYear || month(start) != eMonth || day(start) != eDay {
                if eYear > current_year {
                    result += "\(eYear)年"
                }
                result += "\(eMonth)月\(eDay)日(\(weekday_str_jp(tmp)))"
            }
            if eHour < 23 || eMinute < 59 {
                let str = String(NSString(format: "%02d:%02d", eHour, eMinute))
                result += str
            } else {
                if month(start) == eMonth && day(start) == eDay {
                    result = result.stringByReplacingOccurrencesOfString("〜", withString: "")
                }
            }
        }
            // 日本語以外
        else{
            // Xxx. mm/dd/yyyy at hh:mm
            // 例　Mon. 12/01/2016 08:00 ~ 12:00
            //result += weekday_str(date: start) + ". "
            result += "\(month(date: start))/\(day(date: start))"
            if year(date: start) > current_year {
                result += "/\(year(date: start))"
            }
            
            result += " " // at はつけない
            
            //if hour(start) > 0 || minute(start) > 0 {
            let str = String(NSString(format: "%02d:%02d", hour(date: start), minute(date: start)))
            result += str
            //}
            
            result += " - "
            
            if year(start) != eYear || month(start) != eMonth || day(start) != eDay {
                result += weekday_str(date: tmp) + ". "
                result += "\(eMonth)/\(eDay)"
                if eYear > current_year {
                    result += "/\(eYear)"
                }
                result += " " // at はつけない
            }
            
            if eHour < 23 || eMinute < 59 {
                let str = String(NSString(format: "%02d:%02d", eHour, eMinute))
                result += str
            } else {
                if month(start) == eMonth && day(start) == eDay {
                    result = result.stringByReplacingOccurrencesOfString(" - ", withString: "")
                }
            }
            
        }
        return result
    }
    
    //カレンダー開始日を取得(今日の日付から取得)
    public static func getCalendarStartDate(today: NSDate) -> NSDate {
        var sdate = today
        let del = getTodayIndex(today)
        sdate = DateUtil.calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -del, toDate: today, options: [])!
        return sdate
    }
    
    //今日の日付のインデクスを取得
    public static func getTodayIndex(today: NSDate) -> Int {
        var i = 0
        let weekno = DateUtil.weekday(today)
        if weekno == 1 {
            i = 6
        } else {
            i = weekno - 2
        }
        return i
    }
    
    //今日の日付の00:00:00の日付データを取得
    public static func getTodayStartDate() -> NSDate? {
        let today = NSDate()
        let current_year = DateUtil.year(today)
        let month = DateUtil.month(today)
        let day = DateUtil.day(today)
        let date_formatter: NSDateFormatter = NSDateFormatter()
        let str = String(NSString(format: "%04d/%02d/%02d", current_year, month, day))
        date_formatter.locale     = NSLocale(localeIdentifier: "ja")
        date_formatter.dateFormat = DateUtil.DATE_FORMAT
        let todays: NSDate? = date_formatter.dateFromString( str + " " + DateUtil.DAY_START_STR )
        //print("Today=\(todays)")
        return todays
    }
    
    // 指定のX座標から日付データを取得する
    public static func getDateFromX(x: CGFloat, base: NSDate, hour_width: CGFloat, date_label_width: CGFloat) -> NSDate? {
        var date = base
        let date_formatter: NSDateFormatter = NSDateFormatter()
        let minute_width = hour_width / 60
        let hourf:CGFloat = (x - date_label_width) / hour_width
        var hour:Int = Int(hourf)
        let hourx =  date_label_width + (hour_width * CGFloat(hour))
        let minutef = (x - hourx) / minute_width
        let minute: Int = Int(minutef)
        
        //24時以降の場合は翌日の日付に変換する
        if hour >= 24 {
            date = DateUtil.calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: date, options: [])!
            hour -= 24
        }
        let year = DateUtil.year(date)
        let month = DateUtil.month(date)
        let day = DateUtil.day(date)
        
        let str = String(NSString(format: "%04d/%02d/%02d %02d:%02d:00", year, month, day, hour, minute))
        print("getDateFromX str=" + str)
        date_formatter.locale     = NSLocale(localeIdentifier: "ja")
        date_formatter.dateFormat = DateUtil.DATE_FORMAT
        date = date_formatter.dateFromString( str )!
        return date
    }
    
    //対象の日付のxx:00:00の日付データを取得
    public static func getHourDate(year: Int, month: Int, day: Int, hour: Int) -> NSDate? {
        let date_formatter: NSDateFormatter = NSDateFormatter()
        let str = String(NSString(format: "%04d/%02d/%02d %02d:00:00", year, month, day, hour))
        date_formatter.locale     = NSLocale(localeIdentifier: "ja")
        date_formatter.dateFormat = DateUtil.DATE_FORMAT
        let todays: NSDate? = date_formatter.dateFromString( str )
        return todays
    }
    
    // 日区切りの予定かどうか(時間指定ではない)
    public static func isDaySplitEvent(start: NSDate, end: NSDate) -> Bool {
        if ((DateUtil.hour(start) == 0 && DateUtil.minute(start) == 0) ||
            (DateUtil.hour(start) == 6 && DateUtil.minute(start) == 0))
            &&
            (DateUtil.hour(end) == 23 && DateUtil.minute(end) == 59) {
            return true
        } else {
            return false
        }
    }
    
    //月末日の取得
    public static func getLastDay(var year:Int,var month:Int) -> Int?{
        let dateFormatter:NSDateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "yyyy/MM/dd";
        if month == 12 {
            month = 0
            year++
        }
        let targetDate:NSDate? = dateFormatter.dateFromString(String(format:"%04d/%02d/01",year,month+1));
        if targetDate != nil {
            //月初から一日前を計算し、月末の日付を取得
            let orgDate = NSDate(timeInterval:(24*60*60)*(-1), sinceDate: targetDate!)
            let str:String = dateFormatter.stringFromDate(orgDate)
            let arr = str.componentsSeparatedByString("/")
            return Int(arr.last!)
        }
        
        return nil;
    }
    
    // 翌月を取得
    public static func getNextMonth(var month:Int) -> Int?{
        month++;
        if month > 12 {
            month = 1
        }
        return month
    }
    
    // 空の開始日時
    public static func getBlankDate() -> NSDate? {
        return getHourDate(1970, month: 1, day: 1, hour: 0)
    }
    
    // yy/mm/ddから日付ラベルを生成
    public static func getDatelabel(year: Int, month: Int, day: Int) -> String? {
        let date_formatter: NSDateFormatter = NSDateFormatter()
        let str = String(NSString(format: "%04d/%02d/%02d 00:00:00", year, month, day))
        
        date_formatter.locale     = NSLocale(localeIdentifier: "ja")
        date_formatter.dateFormat = DateUtil.DATE_FORMAT
        let date: NSDate? = date_formatter.dateFromString( str )
        
        var result = ""
        // 日本語の場合
        if(CommonUtil.isJa()){
            
            result = "\(DateUtil.month(date!))月\(DateUtil.day(date!))日(\(DateUtil.weekday_str_jp(date)))"
            
        }else{
            result += DateUtil.weekday_str(date!) + ". "
            result += "\(DateUtil.month(date!))/\(DateUtil.day(date!))"
        }
        return result
    }
    
    // NSDateから文字列型で日時を取得
    public static func getDateStrFromNSDate(date:NSDate)->String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = DateUtil.DATE_FORMAT
        return dateFormatter.stringFromDate(date)
    }
    // 文字列からNSDateを取得
    public static func getDateFromString(str:String)->NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = DateUtil.DATE_FORMAT
        return dateFormatter.dateFromString(str)!
    }
    
    // 過去の予定であればtrueを返す  過去の予定の定義は、「予定の終了日時が、データ上で今日の00:00以前である予定」
    public static func isPassedEvent(event:Event) -> Bool {
        return DateUtil.isAscDate(event.end, d2: DateUtil.getTodayStartDate())
    }
    
    // 00:00であるか？
    public static func is0pm(date: NSDate) -> Bool {
        if DateUtil.hour(date) == 0 && DateUtil.minute(date) == 0 {
            return true
        } else {
            return false
        }
    }
    
    // 分を5分切り上げる
    public static func getDiffMinutes(minute:Int)->Int{
        return Int(ceil(CGFloat(minute)/5))*5-minute
    }
    
    // YYYY/MM/DD の文字列を作成
    public static func makeYYYYMMDD(year:Int, month:Int, day:Int) -> String {
        return String(NSString(format: "%4d/%02d/%02d", year, month, day))
    }
    
    // HH:mm の文字列を作成
    public static func makeHHMM(hour:Int, minute:Int) -> String {
        return String(NSString(format: "%02d", hour)) + ":" + String(NSString(format: "%02d", minute))
    }
    
    // NSDate変数をMMdd HHmm の文字列に変換
    public static func getMMDDHHMMValue(date:NSDate)->String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMdd HHmm"
        return dateFormatter.stringFromDate(date) as String
    }
*/
}
