//
//  ContentView.swift
//  HapticMetronome
//
//  Created by 齋藤修 on 2020/12/18.
//

import SwiftUI

struct ContentView: View {
    
    var timerController: TimerController
    
    private var bpm: Int {
        Int(bpm_str)!
    }
    @State private var bpm_str: String = "120"
    
    private var mode: Int {
        Int(mode_str)!
    }
    @State private var mode_str: String = "0"
    
    var body: some View {
        VStack {
            TextField("BPM", text: $bpm_str)
                .padding()
            TextField("Mode", text: $mode_str)
                .padding()
            Button(action: {timerController.start(mode: mode, bpm: bpm)}) {
                Text("Play")
            }
            .padding()
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
