//
//  NSDate.swift
//  Nickey
//
//  Created by cano on 2016/10/22.
//  Copyright © 2016年 cano. All rights reserved.
//

import UIKit

public extension NSDate {
    /// SwiftRandom extension
    public static func randomWithinDaysBeforeToday(days: Int) -> NSDate {
        let today = NSDate()
        
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
    
    /// SwiftRandom extension
    public static func random() -> NSDate {
        let randomTime = TimeInterval(arc4random_uniform(UInt32.max))
        return NSDate(timeIntervalSince1970: randomTime)
    }
    
}
