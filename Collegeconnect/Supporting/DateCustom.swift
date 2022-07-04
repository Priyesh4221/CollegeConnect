//
//  DateCustom.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 8/8/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import Foundation

class DateCustom {
    
    class func from(year: Int, month: Int, day: Int) -> Date {
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day + 1
        
        let date = gregorianCalendar.date(from: dateComponents)!
        return date
    }
    
    class func parse(_ string: String, format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateFormat = format
        
        let date = dateFormatter.date(from: string)!
        return date
    }
}
