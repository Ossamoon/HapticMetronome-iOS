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
        switch tapletMode {
        case .none: return 1
        case .tap2: return 2
        case .tap3: return 3
        case .tap4: return 4
        }
    }
    @State private var bpm_str: String = "120"
    @State private var beats_str: String = "4"
    @State private var tapletMode: TapletMode = .none
    @State private var hapticMode: HapticMode = .off
    @State private var isPlaying: Bool = false
    
    
    var body: some View {
        VStack {
            TextField("BPM", text: $bpm_str)
                .keyboardType(.numberPad)
                .padding()
            
            TextField("Beats", text: $beats_str)
                .keyboardType(.numberPad)
                .padding()
            
            Picker(selection: $tapletMode, label: Text("TapletMode")) {
                ForEach(TapletMode.allCases) {
                    Text($0.rawValue.capitalized).tag($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Picker(selection: $hapticMode, label: Text("HapticMode")) {
                ForEach(HapticMode.allCases) {
                    Text($0.rawValue.capitalized).tag($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            
            if isPlaying == false {
                Button(action: {
                    hapticMetronome.bpm = Double(self.bpm)
                    hapticMetronome.beats = self.beats
                    hapticMetronome.taplet = self.taplet
                    hapticMetronome.hapticMode = self.hapticMode
                    hapticMetronome.stop()
                    hapticMetronome.play()
                    isPlaying = true
                }) {
                    Text("Play")
                }
                .padding()
            } else {
                Button(action: {
                    hapticMetronome.stop()
                    isPlaying = false
                }) {
                    Text("Stop")
                }
                .padding()
            }
        }
    }
}

enum TapletMode: String, CaseIterable, Identifiable {
    case none = "なし"
    case tap2 = "2連符"
    case tap3 = "3連符"
    case tap4 = "4連符"
    
    var id: String { rawValue }
}

enum HapticMode: String, CaseIterable, Identifiable {
    case off
    case click
    case vibrationShort
    case vibrationLong
    
    var id: String { rawValue }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
