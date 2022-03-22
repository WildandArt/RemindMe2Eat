//
//  NotificationManager.swift
//  RemindMe2Eat
//
//  Created by Artemy Ozerski on 11/01/2022.
//

import Foundation
import UserNotifications

final class NotificationManager : NSObject, ObservableObject{
    let userNotificationCenter = UNUserNotificationCenter.current()
    @Published var pending : [UNNotificationRequest] = []
    @Published var delivered : [UNNotification] = []
    @Published var calculatedTimes : [Date] = []

    override init(){
        super.init()
        userNotificationCenter.delegate = self

        }
    func requestAuthorization(){
        let options = UNAuthorizationOptions([.sound, .alert, .badge])
        userNotificationCenter.requestAuthorization(options: options) { result, error in
            if let error = error {
                print("\(error.localizedDescription)")
            }
            print("Notification Authorization successful:\(result)")
        }
    }
    func prepareIntervalNotification(id: String, interval : Double){
        let content = UNMutableNotificationContent()
        content.title = "Time To eat"
        content.body = "What it will be?"
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        userNotificationCenter.add(request) { error in
            if let error = error{
                print("\(error.localizedDescription)")
            }
            else{}
        }

    }
    func arithmeticSeriesMember(Aone : Date, n : Int, D : Double)-> Date{
         Aone.addingTimeInterval((Double(n) - 1) * D)
    }
    let seriesClosure : (Date, Int, Double)->(Date) = { (startingDate, index, intervalSize ) in
        startingDate.addingTimeInterval((Double(index) - 1) * intervalSize)
    }
    func createCalculatedTimes(now: Date,numberOfMeals: Int, intervalSize : Double){
        let array1 = Array(repeating: 1, count: numberOfMeals).enumerated()
        calculatedTimes = array1.map { index, element in
            seriesClosure(now, index, intervalSize)
    }

}
    func refreshPendingNotifications(){
        userNotificationCenter.getPendingNotificationRequests {  requests in
            DispatchQueue.main.async {
                self.pending = requests
            }
        }
    }
    func refreshDeliveredNotifications(){
        userNotificationCenter.getDeliveredNotifications { notifications in
            DispatchQueue.main.async {
                self.delivered = notifications
            }
        }
    }
}

extension  NotificationManager : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }
}
