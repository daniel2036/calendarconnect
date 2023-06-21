//
//  ConnectCalendar.swift
//  CalendarConnect
//
//  Created by Daniel Xu on 12/20/22.
//

import Foundation

class ConnectCalendar: ObservableObject{
    @Published private var model = MyCalendar()
    
    //returns today's date
    var currentDate: Date{
        return model.currentDate
    }
    
    func setCurrentDate(to dateStr: String){
        model.setCurrentDate(to: dateStr)
    }
    
    func dates() -> [Date] {
        model.datesInYear()
    }
}
