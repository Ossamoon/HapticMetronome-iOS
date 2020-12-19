//
//  HapticMetronomeApp.swift
//  HapticMetronome
//
//  Created by 齋藤修 on 2020/12/18.
//

import SwiftUI

@main
struct HapticMetronomeApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    private var contentView = ContentView(timerController: TimerController())
    
    var body: some Scene {
        WindowGroup {
            contentView
        }.onChange(of: scenePhase) { phase in
            switch phase {
            case .background:
                print("App is in background")
            case .active:
                print("App is Active")
                contentView.onActive()
            case .inactive:
                print("App is Inactive")
                contentView.onInactive()
            @unknown default:
                print("New App state not yet introduced")
            }
        }
    }
}
