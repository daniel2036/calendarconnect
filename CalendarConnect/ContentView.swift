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
        //v1 order of week starts with monday, ends with sunday.
        //v1 allow for customization which day to start week eventually
        //v2 move week array into the weekview subview
//        let week = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        //v1 put week under the month and year
        VStack{
            HStack{
                //v1 the current month and year at the top
                Text(connectCalendar.currentDate.monthYYYY())
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                //v1 interactive icons in top right corner
                HStack{
                    Image(systemName: "calendar")
                    Image(systemName: "tray.fill")
                    Image(systemName: "gear")
                }
                .font(.title)
            }
            
            //v2 edit padding command
//            .padding([.top,.leading,.trailing])
            .padding()
            
            //v2 no longer use geometry reader nor Vstack
//            GeometryReader{ geo in
//                VStack {
                    //v1 stacked "recenter" button under horizontal scrollable calendar
                    
                    //v2 update remove scrollviewreader
//                    ScrollViewReader { proxy in
//                        let datesArray = connectCalendar.dates()
//                        ScrollView(.horizontal, showsIndicators: false){
            
                            //v1 days of the week hstackusing geometry reader and loop
                            //v2 HStack extract subview -> WeekView
            
            //v2 VStack WeekViews to have multiple Monday -> Sundays
//            WeekView()
            //v2 change VStack to Swipeable stack
            //v2 struct a SwipeableStack since it's not built in
//            VStack(content: {
            SwipeableStack(content: {
                WeekView()
                    .background(.cyan)
                WeekView()
                    .background(.yellow)
            })
            
            //v2 spacer here (outside of HStack) to push some contents to the top
            Spacer()
                    
//                        }
                    //v2 removed scrollview and recenter button
//                //v1 default starts at today's date
//                        .onAppear() {
//                            if let pos = datesArray.firstIndex(of: connectCalendar.currentDate) {
//                                proxy.scrollTo(pos, anchor: .center)
//                            }
//                        }
//                //v1 recenter button to today's date
//                        Button("Re-center") {
//                            print(connectCalendar.currentDate)
//                            if let pos = datesArray.firstIndex(of: connectCalendar.currentDate) {
//                                proxy.scrollTo(pos, anchor: .center)
//                            }
//                        }
                    //}
                //}
            //}
        }
        //function test case below to manually set month at top
//        .onAppear {
//            connectCalendar.setCurrentDate(to: "20221201")
//        }
    }
}

//v2 struct swipeableStack
//v2 create new generic type "Content"
//v2 make "Content" a "View" type
struct SwipeableStack<Content>: View where Content: View{
    //v2 ViewBuilder lets us put multiple "views" in the Swipeable stack call
    @ViewBuilder let content: () -> Content
    var body: some View {
        content()
    }
}

        //v2 extracted subview of HStack -> WeekView
struct WeekView: View {
    let week = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    var body: some View {
        HStack{
            //v2 add spacer
            Spacer()
            //v2 return to static weekdays instead of scrolling dates
            //                                ForEach(datesArray.indices,id:\.self){ i in
            
            ForEach(week, id:\.self) { d in
                Text(d)
                
                //                                    let d = datesArray[i]
                //                                    VStack{
                //                                        Text(d.weekDayAbbrev())
                //                                            .fontWeight(.ultraLight)
                //                                        Text(d.dayNum())
                //                                            .fontWeight(.bold)
                //                                    }
                
                //v2 use spacer insead of geometryreader
                Spacer()
                //                                    .frame(width:geo.size.width/8)
            }
        }
    }
}















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
