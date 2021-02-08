//
//  HapticController.swift
//  HapticMetronome
//
//  Created by 齋藤修 on 2020/12/19.
//

import Foundation
import CoreHaptics
import AVFoundation

class HapticMetronome {
    // Metronome Parameter
    var hapticMode: HapticMode = .off
    var bpm: Double = 120.0
    var old_bpm: Double = 120.0
    var beats: Int = 4
    var taplet: Int = 2
    
    // Audio Session
    var audioSession: AVAudioSession
    
    // Audio Data
    private let audioResorceNames: [AudioType: String]  = [
        .middle : "sound_default_middle",
        .strong : "sound_default_strong",
        .weak : "sound_default_weak",
    ]
    private var audioURLs: [AudioType: URL?] = [
        .middle : nil,
        .strong : nil,
        .weak : nil,
    ]
    private var audioResorceIDs: [AudioType: CHHapticAudioResourceID] = [
        .middle : 0,
        .strong : 1,
        .weak : 2,
    ]
    
    // Haptic Engine:
    private var engine: CHHapticEngine!
    
    // Haptic State:
    private var engineNeedsStart = true
    var supportsHaptics: Bool = false
    
    // Haptic Player:
    var player: CHHapticAdvancedPatternPlayer?
    
    // Haptic Event Parameters:
    private let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.4)
    private let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
    private var hapticDurationShort: TimeInterval {
        min(audioDurationStrong, TimeInterval(0.08))
    }
    private var hapticDurationLong: TimeInterval {
        min(audioDurationStrong, TimeInterval(0.18))
    }
    
    // Audio Event Parameters:
    private let audioVolume = CHHapticEventParameter(parameterID: .audioVolume, value: 1.0)
    private var audioDurationMiddle: TimeInterval {
        TimeInterval(60.0 / bpm)
    }
    private var audioDurationStrong: TimeInterval {
        TimeInterval(Double(beats) * 60.0 / bpm)
    }
    private var audioDurationWeak: TimeInterval {
        TimeInterval(60.0 / bpm / Double(taplet))
    }
    
    // Time when the engine started player most recently:
    private var startTime: TimeInterval = 0
    
    
    init(){
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set and activate audio session category.")
        }
        
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        supportsHaptics = hapticCapability.supportsHaptics
        
        for type in AudioType.allCases {
            if let path = Bundle.main.path(forResource: audioResorceNames[type], ofType: "wav") {
                audioURLs[type] = URL(fileURLWithPath: path)
            } else {
                print("Error: Failed to find audioURL_\(type)")
            }
        }
        
        createAndStartHapticEngine()
    }
    
    private func createAndStartHapticEngine() {
        // Check for device compatibility
        guard supportsHaptics else { return }
        
        // Create and configure a haptic engine.
        do {
            engine = try CHHapticEngine(audioSession: audioSession)
        } catch let error {
            fatalError("Engine Creation Error: \(error)")
        }
        
        // The stopped handler alerts engine stoppage.
        engine.stoppedHandler = { reason in
            print("Stop Handler: The engine stopped for reason: \(reason.rawValue)")
            switch reason {
            case .audioSessionInterrupt:
                print("Audio session interrupt.")
            case .applicationSuspended:
                print("Application suspended.")
            case .idleTimeout:
                print("Idle timeout.")
            case .notifyWhenFinished:
                print("Finished.")
            case .systemError:
                print("System error.")
            case .engineDestroyed:
                print("Engine destroyed.")
            case .gameControllerDisconnect:
                print("Controller disconnected.")
            @unknown default:
                print("Unknown error")
            }
            
            // Indicate that the next time the app requires a haptic, the app must call engine.start().
            self.engineNeedsStart = true
        }
        
        // The reset handler notifies the app that it must reload all its content.
        // If necessary, it recreates all players and restarts the engine in response to a server restart.
        engine.resetHandler = {
            print("The engine reset --> Restarting now!")
            
            // Tell the rest of the app to start the engine the next time a haptic is necessary.
            self.engineNeedsStart = true
        }
        
        // Start haptic engine to prepare for use.
        do {
            try engine.start()
            
            // Indicate that the next time the app requires a haptic, the app doesn't need to call engine.start().
            engineNeedsStart = false
        } catch let error {
            print("The engine failed to start with error: \(error)")
        }
    }
    
    func play() {
        // Check for device compatibility
        guard supportsHaptics else { return }
        
        do {
            // Check for engine state
            if engineNeedsStart {
                try engine.start()
                engineNeedsStart = false
            }
            
            // Create haptic pattern
            let pattern = try createPattern()
            
            // Create player
            player = try engine.makeAdvancedPlayer(with: pattern)
            player!.loopEnabled = true
            
            // Culculate when to start player
            var atTime: TimeInterval = CHHapticTimeImmediate
            let currentTime: TimeInterval = self.engine.currentTime
            if startTime != 0 {
                let passedTime: TimeInterval = (currentTime - self.startTime).truncatingRemainder(dividingBy: 60.0 / self.old_bpm)
                let pausingTime: TimeInterval = (60.0 / self.bpm) - passedTime
                print("pausingTime")
                print(pausingTime)
                if pausingTime > 0 {
                    atTime = pausingTime + currentTime
                }
            }
            
            // Start player
            startTime = max(atTime, currentTime)
            try player!.start(atTime: atTime)
            
        } catch let error {
            print("Haptic Playback Error: \(error)")
        }
    }
    
    func stop(){
        guard supportsHaptics else { return }
        engine.stop()
        engineNeedsStart = true
        startTime = 0
        print("engine stopped normally")
    }
    
    private func createPattern() throws -> CHHapticPattern {
        do {
            var eventList: [CHHapticEvent] = []
            
            // Register audio resources
            for type in AudioType.allCases {
                audioResorceIDs[type] = try self.engine.registerAudioResource(audioURLs[type]!!)
            }
            
            // Add events to eventList
            for i in 0..<self.beats {
                let timepoint: TimeInterval = Double(i) * audioDurationMiddle
                if i == 0 && self.beats > 1 {
                    eventList.append(createAudioEvent(type: .strong, relativeTime: timepoint))
                } else {
                    eventList.append(createAudioEvent(type: .middle, relativeTime: timepoint))
                }
                if self.hapticMode != .off {
                    eventList.append(createHapticEvent(type: .click, relativeTime: timepoint))
                }
                if self.hapticMode == .vibrationLong {
                    eventList.append(createHapticEvent(type: .vibrationLong, relativeTime: timepoint))
                }
                if self.hapticMode == .vibrationShort {
                    eventList.append(createHapticEvent(type: .vibrationShort, relativeTime: timepoint))
                }
                
                for j in 0..<self.taplet {
                    let new_timepoint: TimeInterval = timepoint + Double(j) * audioDurationWeak
                    eventList.append(createAudioEvent(type: .weak, relativeTime: new_timepoint))
                }
            }
            
            // Create and Return the pattern
            let pattern = try CHHapticPattern(events: eventList, parameters: [])
            return pattern
            
        } catch let error {
            throw error
        }
    }
    
    
    private func createHapticEvent(type: HapticType, relativeTime: TimeInterval) -> CHHapticEvent {
        var event: CHHapticEvent
        
        switch type {
        case .click:
            event = CHHapticEvent(eventType: .hapticTransient, parameters: [sharpness, intensity], relativeTime: relativeTime)
        case .vibrationShort:
            event = CHHapticEvent(eventType: .hapticContinuous, parameters: [sharpness, intensity], relativeTime: relativeTime, duration: self.hapticDurationShort)
        case .vibrationLong:
            event = CHHapticEvent(eventType: .hapticContinuous, parameters: [sharpness, intensity], relativeTime: relativeTime, duration: self.hapticDurationLong)
        }
        
        return event
    }
    
    
    private func createAudioEvent(type: AudioType, relativeTime: TimeInterval) -> CHHapticEvent {
        var event: CHHapticEvent
        
        switch type {
        case .middle:
            event = CHHapticEvent(audioResourceID: audioResorceIDs[.middle]!, parameters: [audioVolume], relativeTime: relativeTime, duration: self.audioDurationMiddle)
        case .strong:
            event = CHHapticEvent(audioResourceID: audioResorceIDs[.strong]!, parameters: [audioVolume], relativeTime: relativeTime, duration: self.audioDurationStrong)
        case .weak:
            event = CHHapticEvent(audioResourceID: audioResorceIDs[.weak]!, parameters: [audioVolume], relativeTime: relativeTime, duration: self.audioDurationWeak)
        }
        
        return event
    }
    
    
    enum HapticType {
        case click
        case vibrationShort
        case vibrationLong
    }
    
    
    enum AudioType: CaseIterable {
        case middle
        case strong
        case weak
    }
}
