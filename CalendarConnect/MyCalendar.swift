//
//  MyCalendar.swift
//  CalendarConnect
//
//  Created by Daniel Xu on 12/20/22.
//

import Foundation

struct MyCalendar{
    //v1 set the current day
    private(set) var today = Date()
    private(set) var currentDate: Date
    //v5 variable for start of Year
    private(set) var startOfYear: Date
    
    //v1 iso8601 is a calendar format?
    private var calendar = Calendar(identifier: .iso8601)
    
    private let dateFormatter = DateFormatter()
    
    init(){
        //v1 timezone currently set to UTC
        calendar.timeZone = TimeZone(identifier: "UTC")!
        dateFormatter.timeZone = TimeZone(identifier: "UTC")!
        dateFormatter.dateFormat = "yyyyMMdd"
        
        let todayStr = dateFormatter.string(from: today)
        currentDate = dateFormatter.date(from: todayStr)!
        
        //v5 currentYear
        let currentYear = calendar.component(.year, from: currentDate)
        startOfYear = calendar.date(from: DateComponents(year: currentYear, month: 1, day: 1))!
    }
    
    //v1 format the day
    //v1 allow customizations for date format
    mutating func setCurrentDate(to dateStr: String){
        let d = dateFormatter.date(from: dateStr)
        if let d {
            currentDate = d
        }
    }
    
    //v1 dates in the year
    func datesInYear() -> [Date] {
        let currentYear = calendar.component(.year, from: currentDate)
        let startOfYear = calendar.date(from: DateComponents(year: currentYear, month:1, day:1))
        let range = calendar.range(of: .day, in: .year, for: startOfYear!)!
        let datesArrInYear = range.compactMap {
            calendar.date(byAdding: .day, value: $0 - 1, to: startOfYear!)
        }
        return datesArrInYear
    }
    
    //v4 new func to get dates in the week
    func datesInWeek(from date:Date) -> [Date] {
        let range = calendar.range(of: .weekday, in: .weekOfYear, for: date)!
        let datesArrInWeek = range.compactMap {
            calendar.date(byAdding: .day, value: $0 - 1, to:date)
        }
        return datesArrInWeek
    }
    
    //v5 function to get mondays of the year (our calendar starts on monday each week)
    func startDateOfWeeksInAYear() -> [Date] {
        let currentWeek = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: startOfYear)
        let startOfWeek = calendar.date(from: currentWeek)
        let range = calendar.range(of: .weekOfYear, in: .year, for: startOfYear)!
        let startOfWeekArr = range.compactMap {
            calendar.date(byAdding: .weekOfYear, value: $0, to: startOfWeek!)
        }
        return startOfWeekArr
    }
}

//v1 month year
extension Date{
    func monthYYYY() -> String{
        return self.formatted(.dateTime .month(.wide) .year())
    }
    
    func weekDayAbbrev() -> String {
        return self.formatted(.dateTime .weekday(.abbreviated))
    }
    
    func dayNum() -> String{
        return self.formatted(.dateTime .day())
    }
}

