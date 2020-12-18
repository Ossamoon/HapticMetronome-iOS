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
    
    
    init(){
        engine = try! CHHapticEngine()
        try! engine.start()
    }
    
    
    private func createEvent() -> CHHapticEvent{
        
        let eventType = self.eventType
        let duration = self.duration
        let sharpness = self.sharpness
        let intensity = self.intensity
        let hapticEvent = CHHapticEvent(eventType: eventType, parameters: [
            CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness),
            CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
        ], relativeTime: 0, duration: duration)
        
        return hapticEvent
    }
    
    
    func play() {
        
        var events: [CHHapticEvent] = []
        events.append(createEvent())

        guard events.count > 0 else { return }
        let pattern = try! CHHapticPattern(events: events, parameters: [])
        let player = try! engine.makePlayer(with: pattern)
        try! player.start(atTime: CHHapticTimeImmediate)
    }
}
