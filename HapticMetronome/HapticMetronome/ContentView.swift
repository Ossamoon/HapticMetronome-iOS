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
    private var beats: Int {
        Int(beats_str)!
    }
    private var taplet: Int {
        Int(taplet_str)!
    }
    @State private var bpm_str: String = "120"
    @State private var beats_str: String = "4"
    @State private var taplet_str: String = "2"
    @State private var hapticMode: HapticMode = .off
    
    
    var body: some View {
        VStack {
            TextField("BPM", text: $bpm_str)
                .padding()
            
            TextField("Beats", text: $beats_str)
                .padding()
            
            TextField("Taplet", text: $taplet_str)
                .padding()
            
            Picker(selection: $hapticMode, label: Text("HapticMode")) {
                ForEach(HapticMode.allCases) {
                    Text($0.rawValue.capitalized).tag($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Button(action: {
                hapticMetronome.bpm = Double(self.bpm)
                hapticMetronome.beats = self.beats
                hapticMetronome.taplet = self.taplet
                hapticMetronome.hapticMode = self.hapticMode
                hapticMetronome.stop()
                hapticMetronome.play()
            }) {
                Text("Play")
            }
            .padding()
            
            Button(action: {
                hapticMetronome.stop()
            }) {
                Text("Stop")
            }
            .padding()
        }
    }
}

enum HapticMode: String, CaseIterable, Identifiable {
    case off
    case click
    case vibrationShort
    case vibrationLong
    
    var id: String {self.rawValue}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
