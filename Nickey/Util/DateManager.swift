//
//  DateManager.swift
//  Nickey
//
//  Created by cano on 2016/09/13.
//  Copyright © 2016年 cano. All rights reserved.
//

import UIKit

class DateManager{

    var currentMonthOfDates = [Date]() //表記する月の配列
    var selectedDate = Date()
    let daysPerWeek: Int = 7
    var numberOfItems: Int!
    
    //月ごとのセルの数を返すメソッド
    func daysAcquisition() -> Int {
        let rangeOfWeeks = (Calendar.current as NSCalendar).range(of: NSCalendar.Unit.weekOfMonth, in: NSCalendar.Unit.month, for: firstDateOfMonth())
        let numberOfWeeks = rangeOfWeeks.length //月が持つ週の数
        numberOfItems = numberOfWeeks * daysPerWeek //週の数×列の数
        return numberOfItems
    }
    
    //月の初日を取得
    func firstDateOfMonth() -> Date {
        var components = (Calendar.current as NSCalendar).components([.year, .month, .day],
                                                                 from: selectedDate)
        components.day = 1
        let firstDateMonth = Calendar.current.date(from: components)!
        return firstDateMonth
    }

    // ⑴表記する日にちの取得
    func dateForCellAtIndexPath(_ numberOfItems: Int) {
        // ①「月の初日が週の何日目か」を計算する
        let ordinalityOfFirstDay = (Calendar.current as NSCalendar).ordinality(of: NSCalendar.Unit.day, in: NSCalendar.Unit.weekOfMonth, for: firstDateOfMonth())
        for i in 0 ..< numberOfItems {
            // ②「月の初日」と「indexPath.item番目のセルに表示する日」の差を計算する
            var dateComponents = DateComponents()
            dateComponents.day = i - (ordinalityOfFirstDay - 1)
            // ③ 表示する月の初日から②で計算した差を引いた日付を取得
            let date = (Calendar.current as NSCalendar).date(byAdding: dateComponents, to: firstDateOfMonth(), options: NSCalendar.Options(rawValue: 0))!
            // ④配列に追加
            currentMonthOfDates.append(date)
        }
    }
    
    // ⑵表記の変更
    func conversionDateFormat(_ indexPath: IndexPath) -> String {
        dateForCellAtIndexPath(numberOfItems)
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: currentMonthOfDates[(indexPath as NSIndexPath).row])
    }
    
    //前月の表示
    func prevMonth(date: Date) -> Date {
        currentMonthOfDates = []
        selectedDate = date.monthAgoDate(date: selectedDate)
        return selectedDate
    }
    //次月の表示
    func nextMonth(date: Date) -> Date {
        currentMonthOfDates = []
        selectedDate = date.monthLaterDate(date: selectedDate)
        return selectedDate
    }
}

extension Date {
    func monthAgoDate(date:Date) -> Date {
        let addValue = -1
        let calendar = NSCalendar.current
        let dateComponents = NSDateComponents()
        dateComponents.month = addValue
        //return calendar.dateByAddingComponents(dateComponents, toDate: self, options: NSCalendar.Options(rawValue: 0))!
        //return calendar.date(byAdding: .month, value: 1, to: Date(), options: [])
        
        return (calendar.date(byAdding: .month, value: -1, to: date))!
    }
    
    func monthLaterDate(date:Date) -> Date {
        let addValue: Int = 1
        let calendar = NSCalendar.current
        let dateComponents = NSDateComponents()
        dateComponents.month = addValue
        //return calendar.dateByAddingComponents(dateComponents, toDate: self, options: NSCalendar.Options(rawValue: 0))!
        return (calendar.date(byAdding: .month, value: 1, to: date))!
    }
    
}

/*
class Date: NSObject {
    
    //前月の表示
    func prevMonth(date: NSDate) -> NSDate {
        currentMonthOfDates = []
        selectedDate = date.monthAgoDate()
        return selectedDate
    }
    //次月の表示
    func nextMonth(date: NSDate) -> NSDate {
        currentMonthOfDates = []
        selectedDate = date.monthLaterDate()
        return selectedDate
    }
}
 */
