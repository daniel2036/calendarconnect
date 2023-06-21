//
//  ContentView.swift
//  CalendarConnect
//
//  Created by Daniel Xu on 12/20/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var connectCalendar = ConnectCalendar()
    var body: some View {
        //order of week starts with monday, ends with sunday.
        //allow for customization which day to start week eventually
//        let week = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        //put week under the month and year
        VStack{
            HStack{
                //the current month and year at the top
                Text(connectCalendar.currentDate.monthYYYY())
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                //interactive icons in top right corner
                HStack{
                    Image(systemName: "calendar")
                    Image(systemName: "tray.fill")
                    Image(systemName: "gear")
                }
                .font(.title)
            }
            .padding([.top,.leading,.trailing])
            GeometryReader{ geo in
                VStack {
                    //stacked jump to today button under horizontal scrollable calendar
                    ScrollViewReader { proxy in
                        let datesArray = connectCalendar.dates()
                        ScrollView(.horizontal, showsIndicators: false){
                            //days of the week hstack
                            HStack{
                                ForEach(datesArray.indices,id:\.self){ i in
                                    let d = datesArray[i]
                                    VStack{
                                        Text(d.weekDayAbbrev())
                                            .fontWeight(.ultraLight)
                                        Text(d.dayNum())
                                            .fontWeight(.bold)
                                    }
                                    .frame(width:geo.size.width/8)
                                }
                            }
                        }
                //default starts at today's date
                        .onAppear() {
                            if let pos = datesArray.firstIndex(of: connectCalendar.currentDate) {
                                proxy.scrollTo(pos, anchor: .center)
                            }
                        }
                //recenter button to today's date
                        Button("Re-center") {
                            print(connectCalendar.currentDate)
                            if let pos = datesArray.firstIndex(of: connectCalendar.currentDate) {
                                proxy.scrollTo(pos, anchor: .center)
                            }
                        }
                    }
                }
            }
        }
        //function test case below to manually set month at top
//        .onAppear {
//            connectCalendar.setCurrentDate(to: "20221201")
//        }
    }
}

















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
