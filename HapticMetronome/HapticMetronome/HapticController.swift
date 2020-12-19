//
//  HapticController.swift
//  HapticMetronome
//
//  Created by 齋藤修 on 2020/12/19.
//

import Foundation
import CoreHaptics

struct HapticController {
    
    var mode: Int = 0
    
    private var engine: CHHapticEngine
    
    private let sharpness: Float = 0.4
    private let intensity: Float = 1.0
    private var eventType: CHHapticEvent.EventType {
        self.mode == 0 ? .hapticTransient : .hapticContinuous
    }
    private var duration: TimeInterval {
        TimeInterval(0.1 * Double(mode))
    }
    
    private var hapticEvent: CHHapticEvent {
        CHHapticEvent(eventType: self.eventType, parameters: [
            CHHapticEventParameter(parameterID: .hapticSharpness, value: self.sharpness),
            CHHapticEventParameter(parameterID: .hapticIntensity, value: self.intensity),
        ], relativeTime: 0, duration: self.duration)
    }
    
    
    init(){
        self.engine = try! CHHapticEngine()
    }
    
    
    func play() {
        
        let pattern = try! CHHapticPattern(events: [self.hapticEvent], parameters: [])
        let player = try! engine.makePlayer(with: pattern)
        do {
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            print("error occurs at starting haptic player")
            print(error.localizedDescription)
        }
    }
    
    func engineStart(){
        do {
            try engine.start()
            print("engine started")
        } catch {
            print("error occurs at starting haptic engine")
            print(error.localizedDescription)
        }
    }
    
    func engineStop(){
        engine.stop(completionHandler: nil)
        print("engine stopped")
    }
}
