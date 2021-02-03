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
    @State private var selectedMode: HapticMode = HapticMode.none
    
    var body: some View {
        VStack {
            TextField("BPM", text: $bpm_str)
                .padding()
            Picker(selection: $selectedMode, label: Text("Haptic Mode")) {
                ForEach(HapticMode.allCases) {
                    Text($0.rawValue.capitalized).tag($0)
                }
            }
            Button(action: {
                hapticMetronome.bpm = Double(self.bpm)
                hapticMetronome.mode = self.selectedMode
                hapticMetronome.play()
            }) {
                Text("Play")
            }
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
    case none
    case click
    case vibrationShort
    case vibrationLong
    case clickAndVibrationShort
    case clickAndVibrationLong
    
    var id: String {self.rawValue}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
