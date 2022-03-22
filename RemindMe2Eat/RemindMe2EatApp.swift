//
//  RemindMe2EatApp.swift
//  RemindMe2Eat
//
//  Created by Artemy Ozerski on 11/01/2022.
//

import SwiftUI

@main
struct RemindMe2EatApp: App {

    @StateObject var notificationManager = NotificationManager()

    var body: some Scene {

        WindowGroup {
            ContentView()
                .environmentObject(notificationManager)
                .onAppear {
                    notificationManager.requestAuthorization()
                }
        }
    }
}
