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
    var modeClick: Click = .off
    var modeVibration: Vibrasion = .off
    var bpm: Double = 120.0
    
    // Audio Session
    var audioSession: AVAudioSession
    
    // Audio Data
    private var audioURL: URL?
    private var audioResorceId: CHHapticAudioResourceID = 0
    
    // Haptic Engine & State:
    private var engine: CHHapticEngine!
    private var engineNeedsStart = true
    var supportsHaptics: Bool = false
    
    // Haptic Player:
    var player: CHHapticAdvancedPatternPlayer?
    
    // Haptic Event Parameters:
    private let sharpness: Float = 0.4
    private let intensity: Float = 1.0
    private var hapticDurationShort: TimeInterval {
        min(audioDuration, TimeInterval(0.08))
    }
    private var hapticDurationLong: TimeInterval {
        min(audioDuration, TimeInterval(0.18))
    }
    
    // Audio Event Parameters:
    private let audioVolume: Float = 1.0
    private var audioDuration: TimeInterval {
        TimeInterval(60.0 / bpm)
    }
    
    // Haptic and Audio Events
    private var hapticClickEvent: CHHapticEvent {
        CHHapticEvent(eventType: .hapticTransient, parameters: [
            CHHapticEventParameter(parameterID: .hapticSharpness, value: self.sharpness),
            CHHapticEventParameter(parameterID: .hapticIntensity, value: self.intensity),
        ], relativeTime: 0)
    }
    private var hapticVibrationShortEvent: CHHapticEvent {
        CHHapticEvent(eventType: .hapticContinuous, parameters: [
            CHHapticEventParameter(parameterID: .hapticSharpness, value: self.sharpness),
            CHHapticEventParameter(parameterID: .hapticIntensity, value: self.intensity),
        ], relativeTime: 0, duration: self.hapticDurationShort)
    }
    private var hapticVibrationLongEvent: CHHapticEvent {
        CHHapticEvent(eventType: .hapticContinuous, parameters: [
            CHHapticEventParameter(parameterID: .hapticSharpness, value: self.sharpness),
            CHHapticEventParameter(parameterID: .hapticIntensity, value: self.intensity),
        ], relativeTime: 0, duration: self.hapticDurationLong)
    }
    private var audioEvent: CHHapticEvent {
        CHHapticEvent(audioResourceID: audioResorceId, parameters: [ CHHapticEventParameter(parameterID: .audioVolume, value: self.audioVolume)], relativeTime: 0, duration: self.audioDuration)
    }
    
    
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
        
        if let path = Bundle.main.path(forResource: "sound1", ofType: "aif") {
            audioURL = URL(fileURLWithPath: path)
        } else {
            print("Error: Failed to find audioURL")
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
            audioResorceId = try engine.registerAudioResource(audioURL!)
            var eventList: [CHHapticEvent] = []
            eventList.append(audioEvent)
            switch self.modeClick {
            case .on:
                eventList.append(hapticClickEvent)
            case .off:
                break
            }
            switch self.modeVibration {
            case .short:
                eventList.append(hapticVibrationShortEvent)
            case .long:
                eventList.append(hapticVibrationLongEvent)
            case .off:
                break
            }
            let pattern = try CHHapticPattern(events: eventList, parameters: [])
            
            // Create and start player
            player = try engine.makeAdvancedPlayer(with: pattern)
            player!.loopEnabled = true
            try player!.start(atTime: CHHapticTimeImmediate)
        } catch let error {
            print("Haptic Playback Error: \(error)")
        }
    }
    
    func stop(){
        guard supportsHaptics else { return }
        engine.stop()
        engineNeedsStart = true
        print("engine stopped normally")
    }
}
