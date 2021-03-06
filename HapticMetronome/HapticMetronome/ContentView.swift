//
//  ContentView.swift
//  HapticMetronome
//
//  Created by 齋藤修 on 2020/12/18.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var hapticMetronome: HapticMetronome = HapticMetronome()
    
    @State private var bpm: Int = 120
    private var beats: Int {
        switch beatsMode {
        case .none: return 1
        case .beat2: return 2
        case .beat3: return 3
        case .beat4: return 4
        case .beat5: return 5
        case .beat6: return 6
        case .beat7: return 7
        case .beat8: return 8
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
    @State private var beatsMode: BeatsMode = .beat4
    @State private var tapletMode: TapletMode = .tap2
    @State private var hapticMode: HapticMode = .vibrationShort
    @State private var isPlaying: Bool = false
    
    @State private var timer: Timer!
    @State private var isLongPressing = false
    
    private let screenWidth = UIScreen.main.bounds.width
    
    private var angle: Angle {
        if hapticMetronome.isComingBack {
            return Angle(degrees: 150.0 - 120.0 * hapticMetronome.rateInBeat)
        } else {
            return Angle(degrees: 30.0 + 120.0 * hapticMetronome.rateInBeat)
        }
    }
    
    var body: some View {
        
        VStack {
            Spacer()
            
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            Capsule()
                                .frame(width: geometry.size.height, height: 12.0)
                                .foregroundColor(.orange)
                                .rotationEffect(self.angle, anchor: .trailing)
                        }
                    }
                    .frame(width: geometry.size.width / 2, height: geometry.size.height)
                    .background(Color.clear)
                    
                    HStack { }
                        .frame(width: geometry.size.width / 2, height: geometry.size.height)
                        .foregroundColor(.clear)
                }
            }
            .frame(width: screenWidth, height: screenWidth / 2)
            
            Group {
                Spacer()
                
                Picker("BeatsMode", selection: $beatsMode) {
                    Text("none").tag(BeatsMode.none)
                    Text("beat2").tag(BeatsMode.beat2)
                    Text("beat3").tag(BeatsMode.beat3)
                    Text("beat4").tag(BeatsMode.beat4)
                    Text("beat5").tag(BeatsMode.beat5)
                    Text("beat6").tag(BeatsMode.beat6)
                    Text("beat7").tag(BeatsMode.beat7)
                    Text("beat8").tag(BeatsMode.beat8)
                }
                .pickerStyle(SegmentedPickerStyle())
                .disabled(isPlaying)
                .padding(.horizontal, 8.0)
                
                Spacer()
                
                Picker("TapletMode", selection: $tapletMode) {
                    Text("none").tag(TapletMode.none)
                    Text("tap2").tag(TapletMode.tap2)
                    Text("tap3").tag(TapletMode.tap3)
                    Text("tap4").tag(TapletMode.tap4)
                }
                .pickerStyle(SegmentedPickerStyle())
                .disabled(isPlaying)
                .padding(.horizontal, 8.0)
                
                Spacer()
                
                Picker("HapticMode", selection: $hapticMode) {
                    Text("off").tag(HapticMode.off)
                    Text("click").tag(HapticMode.click)
                    Text("vibrationShort").tag(HapticMode.vibrationShort)
                    Text("vibrationLong").tag(HapticMode.vibrationLong)
                }
                .pickerStyle(SegmentedPickerStyle())
                .disabled(isPlaying)
                .padding(.horizontal, 8.0)
                
                Spacer()
                Spacer()
            }
            
            HStack {
                Spacer()
                
                Button(action: {
                    self.bpm = max(self.bpm / 2, 12)
                }) {
                    HStack(spacing: 0) {
                        Image(systemName: "divide")
                            .font(.system(size: 18, weight: .regular, design: .default))
                        Text("2")
                            .font(.system(size: 22, weight: .regular, design: .default))
                    }
                    .frame(width: 42.0, height: 30.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 3.0)
                            .stroke()
                    )
                }
                .disabled(isPlaying)
                
                Group {
                    Spacer()
                    Spacer()
                    
                    Button(action: {
                        if(self.isLongPressing){
                            //this tap was caused by the end of a longpress gesture, so stop our fastforwarding
                            self.isLongPressing.toggle()
                            self.timer?.invalidate()
                        } else {
                            //just a regular tap
                            if self.bpm > 12 { self.bpm -= 1 }
                        }
                    }, label: {
                        Image(systemName: "minus.square")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44.0, height: 44.0)
                    })
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: 0.2).onEnded { _ in
                            self.isLongPressing = true
                            self.timer = Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true, block: { _ in
                                self.bpm -= 1
                        })
                    })
                    .disabled(isPlaying)
                    
                    Spacer()
                    
                    VStack {
                        Text("BPM")
                            .font(.system(size: 20, weight: .regular, design: .default))
                        
                        Text(String(bpm))
                            .font(.system(size: 68, weight: .regular, design: .default))
                    }
                    .frame(width: 124.0)
                    
                    Spacer()
                    
                    Button(action: {
                        if(self.isLongPressing){
                            self.isLongPressing.toggle()
                            self.timer?.invalidate()
                        } else {
                            if self.bpm < 280 { self.bpm += 1 }
                        }
                    }, label: {
                        Image(systemName: "plus.square")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44.0, height: 44.0)
                    })
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: 0.2).onEnded { _ in
                            self.isLongPressing = true
                            self.timer = Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true, block: { _ in
                                if self.bpm < 280 { self.bpm += 1 }
                        })
                    })
                    .disabled(isPlaying)
                    
                    Spacer()
                    Spacer()
                }
                
                Button(action: {
                    self.bpm = min(self.bpm * 2, 280)
                }) {
                    HStack(spacing: 0) {
                        Image(systemName: "multiply")
                            .font(.system(size: 18, weight: .regular, design: .default))
                        Text("2")
                            .font(.system(size: 22, weight: .regular, design: .default))
                    }
                    .frame(width: 42.0, height: 30.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 3.0)
                            .stroke()
                    )
                }
                .disabled(isPlaying)
                
                Spacer()
            }
            
            Spacer()
            
            if isPlaying == false {
                VStack {
                    Button(action: {
                        hapticMetronome.bpm = Double(self.bpm)
                        hapticMetronome.beats = self.beats
                        hapticMetronome.taplet = self.taplet
                        hapticMetronome.hapticMode = self.hapticMode
                        hapticMetronome.play()
                        isPlaying = true
                    }) {
                        Image(systemName: "play.circle")
                            .resizable()
                            .frame(width: 80.0, height: 80.0)
                        
                    }
                    
                    Text("start")
                        .font(.system(size: 18, weight: .regular, design: .default))
                        .foregroundColor(Color.gray)
                }
            } else {
                VStack {
                    Button(action: {
                        self.stop()
                    }) {
                        Image(systemName: "stop.circle")
                            .resizable()
                            .frame(width: 80.0, height: 80.0)
                    }
                    
                    Text("stop")
                        .font(.system(size: 18, weight: .regular, design: .default))
                        .foregroundColor(Color.gray)
                }
            }
            
            Spacer()
        }
    }
    
    func stop() {
        self.hapticMetronome.stop()
        self.isPlaying = false
    }
}

enum BeatsMode: String, CaseIterable, Identifiable {
    case none
    case beat2
    case beat3
    case beat4
    case beat5
    case beat6
    case beat7
    case beat8
    
    var id: String { rawValue }
}

enum TapletMode: String, CaseIterable, Identifiable {
    case none
    case tap2
    case tap3
    case tap4
    
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
        Group {
            ContentView()
            ContentView()
                .environment(\.locale, .init(identifier: "ja"))
        }
    }
}
