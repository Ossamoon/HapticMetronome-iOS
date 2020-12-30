//
//  TimerController.swift
//  HapticMetronome
//
//  Created by 齋藤修 on 2020/12/19.
//

import Foundation

class TimerController {
    
    private var timer = Timer()
    
    private var bpm: Double = 240.0
    
    private var hapticController = HapticController()
    private var soundController = SoundController()
    
    
    func prepare() {
        hapticController.engineStart()
        soundController.prepare()
    }
    
    func start(mode: Int, bpm: Int) {
        self.timer.invalidate()
        self.bpm = Double(bpm)
        hapticController.mode = mode
        self.timer = Timer.scheduledTimer(withTimeInterval: 60.0 / self.bpm, repeats: true){
            _ in
            self.soundController.play()
            self.hapticController.play()
        }
    }
    
    func stop() {
        self.timer.invalidate()
        hapticController.engineStop()
        self.soundController.stop()
    }
}
