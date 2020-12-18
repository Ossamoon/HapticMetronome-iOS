//
//  ContentView.swift
//  HapticMetronome
//
//  Created by 齋藤修 on 2020/12/18.
//

import SwiftUI

struct ContentView: View {
    
    var timerController = TimerController()
    
    var body: some View {
        Button(action: timerController.start) {
                Text("Play")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
