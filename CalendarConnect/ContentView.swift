//
//  ContentView.swift
//  CalendarConnect
//
//  Created by Daniel Xu on 12/20/22.
//

import SwiftUI

struct ContentView: View {
//    @ObservedObject var connectCalendar = ConnectCalendar()
    //v4 state object instead of observed object
    @StateObject var connectCalendar = ConnectCalendar()
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
            
            //v4 make it so array only has one element
            //v5 comment let today out
//            let today = Date()
            
            //v3 made 3 week arr, replaced "content" with "arr" in swipeable stack. rewrote swipeable stack
            //v5 comment out today arr
//            let arr = [today]
            //v5 replace "data: arr" inside swipeable stack
            SwipeableStack(data: connectCalendar.startDateOfWeeksInAYear()) {
                date in WeekView(of: date)
            }
            //v4 weekview of:data. no longer list everything in array.
//            SwipeableStack(content: {
//                WeekView()
//                    .background(.cyan)
//                WeekView()
//                    .background(.yellow)
//            })
            
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
        //v4 create environment object for the stateobject
        .environmentObject(connectCalendar)
        //function test case below to manually set month at top
//        .onAppear {
//            connectCalendar.setCurrentDate(to: "20221201")
//        }
    }
}

//v2 struct swipeableStack
//v2 create new generic type "Content"
//v2 make "Content" a "View" type
//v3 added whatevertypeofdata to swipeable stack parameter.
struct SwipeableStack<WhateverTypeOfData: Hashable, Content>: View where Content: View{
    //v3 created whateverData
    var whateverData: [WhateverTypeOfData] = []
    //v2 ViewBuilder lets us put multiple "views" in the Swipeable stack call
    //v3 delete @viewBuilder
//    @ViewBuilder let content: () -> Content
    let content: (WhateverTypeOfData) -> Content
    
    //v3 new initializer
    init(data: [WhateverTypeOfData], @ViewBuilder content: @escaping (WhateverTypeOfData) -> Content) {
        self.whateverData = data
        self.content = content
    }
    //v4 variable to keep track of which weekview in content(whateverData[index])
    @State private var dataIndex = 0
    //v3 variable to measure horizontal scrolling
    @State private var dragged = CGSize.zero
    //v4 establish previousExist used below in the geometryreader and hstack. >= 0 means
    var previousExist: Bool {
        return (dataIndex - 1) >= 0
        //dataIndex-1 >= 0 means we are not at beginning of array, then there is data previous to the current
    }
    //v4 check if there is data after the current one with nextExist.
    var nextExist: Bool {
        return dataIndex < whateverData.count - 1
    }
    
    var body: some View {
        //v3 put content in an hstack
        //v3 put in geometry reader to make 1 week take the screen instead of 3 which is cramped
        GeometryReader { geo in
            //v4 added frameWidth variable for content in hstack below.
            let frameWidth = geo.size.width
            HStack(spacing: 0){
                //v3 added whateverData[0] inside content()
                //v3 used for each
                //            content(whateverData[0])
                //v4 commented out forloop, manually make 3 weeks for calendar.
                //future make background colors customizable
                //v4 checks if there was previous existing values
                if previousExist{
                    content(whateverData[dataIndex - 1]) /*previous*/
                        .frame(width: frameWidth)
                        .background(.green)
                        .offset(x: previousExist ? -frameWidth: 0)
                }
                content(whateverData[dataIndex]) /*current*/
                    .frame(width: frameWidth)
                    .background(.blue)
                    .offset(x: previousExist ? -frameWidth: 0)
                //v4 implement nextExist
                if nextExist{
                    content(whateverData[dataIndex + 1]) /*next*/
                        .frame(width: frameWidth)
                        .background(.yellow)
                        .offset(x: previousExist ? -frameWidth: 0)
                }
    //                ForEach(whateverData, id: \.self) { data in content(data)
    //                        .frame(width: geo.size.width)
    //                }
            }
            //v3 gesture to allow drag screen to scroll horizontally. offset tells how much drag movement. dragged is variable above.
            //v3 onChanged allows us to drag the weekdays horizontally and see the next week.
            .offset(x: dragged.width)
            .gesture(DragGesture()
                .onChanged{ value in
                    dragged.width = value.translation.width
                }
                //v4 onEnded, when drag ends, show the next week.
                .onEnded { value in
                    var indexOffset = 0
                    
                    withAnimation(.easeInOut(duration: 0.3)) {
                        //v4 if not dragged enough, will go back to default position
                        dragged = CGSize.zero
                        //v4 if statements below to determine if offset left or right based on how much drag. can only move if present pages
                        if value.predictedEndTranslation.width < -frameWidth/2 && nextExist {
                            dragged.width = -frameWidth
                            indexOffset = 1 /*Next*/
                        }
                        if value.predictedEndTranslation.width > frameWidth/2 && previousExist {
                            dragged.width = frameWidth
                            indexOffset = -1 /*Previous*/
                        }
                    }
                    //v4 not dragged enough, go back to default position by setting a timer, if action takes longer than animation, reset
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        dataIndex += indexOffset
                        dragged = CGSize.zero
                    }
                }
            )
        }
    }
}

        //v2 extracted subview of HStack -> WeekView
struct WeekView: View {
    //v4 state view model implementation
    @EnvironmentObject var connectcalendar: ConnectCalendar
    //v4 dates in a week. used above so there will only be one variable. no need for every day of the week to be listed in a variable.
    let date: Date
    init(of date: Date) {
        self.date = date
    }
    
    let week = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    var body: some View {
        //v4 implement datesinweekview
        let datesInWeek = connectcalendar.datesInWeek(from: date)
        HStack{
            //v2 add spacer
            Spacer()
            //v2 return to static weekdays instead of scrolling dates
            //                                ForEach(datesArray.indices,id:\.self){ i in
            
            //v4 change forEach contents
//            ForEach(week, id:\.self) { d in
            ForEach(datesInWeek.indices, id:\.self) { i in
                let d = datesInWeek[i]
                VStack{
                    Text(week[i])
                    Text(d.dayNum())
                }
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
