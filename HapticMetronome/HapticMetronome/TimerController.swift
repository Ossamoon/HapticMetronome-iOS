//
//  TimerController.swift
//  HapticMetronome
//
//  Created by 齋藤修 on 2020/12/19.
//

import Foundation

class TimerController {
    var bpm: Double = 120.0
    var hapticController = HapticController()
    private var timer = Timer()
    
    func start() {
        self.timer.invalidate()
        hapticController.mode = 0
        self.timer = Timer.scheduledTimer(withTimeInterval: 60.0 / bpm, repeats: true){
            _ in
            self.hapticController.play()
        }
    }
}
