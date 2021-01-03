//
//  ContentView.swift
//  HapticMetronome
//
//  Created by 齋藤修 on 2020/12/18.
//

import SwiftUI

struct ContentView: View {
    
    var hapticMetronome: HapticMetronome = HapticMetronome()
    
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
            Button(action: {
                hapticMetronome.bpm = Double(self.bpm)
                hapticMetronome.mode = self.mode
                hapticMetronome.play()
            }) {
                Text("Play")
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
