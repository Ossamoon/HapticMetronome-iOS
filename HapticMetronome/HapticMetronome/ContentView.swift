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
        switch beatsMode {
        case .none: return 1
        case .beat2: return 2
        case .beat3: return 3
        case .beat4: return 4
        case .beat5: return 5
        case .beat6: return 6
        case .beat7: return 7
        }
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
    @State private var beatsMode: BeatsMode = .beat4
    @State private var tapletMode: TapletMode = .tap2
    @State private var hapticMode: HapticMode = .off
    @State private var isPlaying: Bool = false
    
    
    var body: some View {
        VStack {
            TextField("BPM", text: $bpm_str)
                .keyboardType(.numberPad)
                .padding()
            
            Picker(selection: $beatsMode, label: Text("BeatsMode")) {
                ForEach(BeatsMode.allCases) {
                    Text($0.rawValue).tag($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Picker(selection: $tapletMode, label: Text("TapletMode")) {
                ForEach(TapletMode.allCases) {
                    Text($0.rawValue).tag($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Picker(selection: $hapticMode, label: Text("HapticMode")) {
                ForEach(HapticMode.allCases) {
                    Text($0.rawValue).tag($0)
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

enum BeatsMode: String, CaseIterable, Identifiable {
    case none = "なし"
    case beat2 = "2拍子"
    case beat3 = "3拍子"
    case beat4 = "4拍子"
    case beat5 = "5拍子"
    case beat6 = "6拍子"
    case beat7 = "7拍子"
    
    var id: String { rawValue }
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
