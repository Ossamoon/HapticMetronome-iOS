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
    @State private var click: Click = .off
    @State private var vibration: Vibrasion = .off
    
    
    var body: some View {
        VStack {
            TextField("BPM", text: $bpm_str)
                .padding()
            
            Picker(selection: $click, label: Text("Click")) {
                ForEach(Click.allCases) {
                    Text($0.rawValue.capitalized).tag($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Picker(selection: $vibration, label: Text("Vibrasion")) {
                ForEach(Vibrasion.allCases) {
                    Text($0.rawValue.capitalized).tag($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Button(action: {
                hapticMetronome.bpm = Double(self.bpm)
                hapticMetronome.modeClick = self.click
                hapticMetronome.modeVibration = self.vibration
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

enum Click: String, CaseIterable, Identifiable {
    case off
    case on
    
    var id: String {self.rawValue}
}

enum Vibrasion: String, CaseIterable, Identifiable {
    case off
    case short
    case long
    
    var id: String {self.rawValue}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
