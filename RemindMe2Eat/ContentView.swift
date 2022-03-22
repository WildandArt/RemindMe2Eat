//
//  ContentView.swift
//  RemindMe2Eat
//
//  Created by Artemy Ozerski on 11/01/2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var notificationManager  : NotificationManager

    @State var numberOfMeals = 2
    @ObservedObject var input = NumbersOnly()
    @State var isSheetShown = false

    var body: some View {
        VStack(alignment: .center){
            Spacer()
            Text("Starting Point : NOW")
            Text("number of meals: \(numberOfMeals + 1) including Now-Meal")
            Stepper  (""){
                numberOfMeals += 1
            } onDecrement: {
                numberOfMeals -= 1
                if numberOfMeals < 1{numberOfMeals = 1}
            }.frame(width: 100, height: 55, alignment: .center)

            TextField("Enter Interval in minutes: ", text: $input.intervalSize)
                .keyboardType(.decimalPad)
                .padding()
                .frame(width: 200, height: 55, alignment: .center)
                .background(Color.init(uiColor: .systemGray4))
                .cornerRadius(10)
Spacer()
            Button {
                print("tapped")
                //let now = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .full)
                let intervalSize = 60 * (input.intervalSize as NSString).doubleValue//in seconds
                let timeIntervals = (1...numberOfMeals).map { i in
                    Double(i) * intervalSize
                }
                timeIntervals.forEach { interval in
                    notificationManager.prepareIntervalNotification(id: UUID().uuidString, interval: interval)
                }
                notificationManager.refreshPendingNotifications()
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            } label: {

                Text("Start Now".uppercased())
            }
            .buttonStyle(.bordered)

            Text("Pending Notifications:")
                .onTapGesture {
                    print("tapped")
                }

            List{
                ForEach(notificationManager.pending, id: \.self) {
                    row in
//                    Text(DateFormatter.localizedString(from: row.identifier, dateStyle: .short, timeStyle: .full))
                    Text(row.identifier)

                }
            }.frame(width: 200, height: 200, alignment: .center)
            HStack{
                Button {
                    notificationManager.userNotificationCenter.removeAllPendingNotificationRequests()
                    notificationManager.refreshPendingNotifications()
                } label: {
                    Text("Remove Pending")
                        .frame(maxWidth: .infinity, maxHeight: 55)
                        .buttonStyle(.bordered)
                        .background(Color.pink)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .padding()



                }
                Button {
                    notificationManager.refreshDeliveredNotifications()
                    isSheetShown.toggle()
                } label: {
                    Text("Show Delivered")
                        .frame(maxWidth: .infinity, maxHeight: 55)
                        .buttonStyle(.bordered)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .padding()
                }

            }



        }.onAppear {
            notificationManager.refreshPendingNotifications()
            notificationManager.refreshDeliveredNotifications()

        }
        .sheet(isPresented: $isSheetShown) {

            ZStack{
                VStack{
                    Spacer()
                    Text("Delivered:")
                        .frame(width: 100, height: 55, alignment: .center)
                    List{
                        ForEach( notificationManager.delivered, id: \.self) {
                            row in
                            Text(DateFormatter.localizedString(from: row.date, dateStyle: .short, timeStyle: .full))
                        }
                    }
                    Spacer()
                }
            }.ignoresSafeArea()
        }
        



    }

}



//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
