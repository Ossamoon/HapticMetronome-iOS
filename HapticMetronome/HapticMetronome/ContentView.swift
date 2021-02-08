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
    @State private var hapticMode: HapticMode = .off
    
    
    var body: some View {
        VStack {
            TextField("BPM", text: $bpm_str)
                .padding()
            
            Picker(selection: $hapticMode, label: Text("HapticMode")) {
                ForEach(HapticMode.allCases) {
                    Text($0.rawValue.capitalized).tag($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Button(action: {
                hapticMetronome.old_bpm = hapticMetronome.bpm
                hapticMetronome.bpm = Double(self.bpm)
                hapticMetronome.hapticMode = self.hapticMode
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
