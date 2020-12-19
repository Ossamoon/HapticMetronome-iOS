//
//  ContentView.swift
//  HapticMetronome
//
//  Created by 齋藤修 on 2020/12/18.
//

import SwiftUI

struct ContentView: View {
    
    var timerController: TimerController
    
    var body: some View {
        VStack {
            Button(action: {timerController.start(mode: 0)}) {
                Text("Play mode 0")
            }
            Button(action: {timerController.start(mode: 1)}) {
                Text("Play mode 1")
            }
            Button(action: {timerController.start(mode: 2)}) {
                Text("Play mode 2")
            }
        }
    }
    
    func onActive() {
        timerController.prepare()
    }
    
    func onInactive() {
        timerController.stop()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(timerController: TimerController())
    }
}
